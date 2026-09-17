import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/layout/contexto_layout.dart';
import '../../../../core/utilidades/validadores.dart';
import '../../../../shared/shared.dart';
import '../../dominio/vehiculo.dart';
import '../proveedores/vehiculos_proveedores.dart';

class FormularioVehiculo extends ConsumerStatefulWidget {
  final int clienteId;
  final Vehiculo? vehiculo;

  const FormularioVehiculo({
    super.key,
    required this.clienteId,
    this.vehiculo,
  });

  @override
  ConsumerState<FormularioVehiculo> createState() => _FormularioVehiculoState();
}

class _FormularioVehiculoState extends ConsumerState<FormularioVehiculo> {
  final _claveFormulario = GlobalKey<FormState>();
  late final TextEditingController _marca;
  late final TextEditingController _modelo;
  late final TextEditingController _anio;
  late final TextEditingController _patente;
  late final TextEditingController _kilometraje;
  bool _guardando = false;
  bool _modificado = false;

  bool get _esEdicion => widget.vehiculo != null;

  @override
  void initState() {
    super.initState();
    final v = widget.vehiculo;
    _marca = TextEditingController(text: v?.marca ?? '')..addListener(_marcarModificado);
    _modelo = TextEditingController(text: v?.modelo ?? '')..addListener(_marcarModificado);
    _anio = TextEditingController(text: v?.anio.toString() ?? '')..addListener(_marcarModificado);
    _patente = TextEditingController(text: v?.patente ?? '')..addListener(_marcarModificado);
    _kilometraje = TextEditingController(text: v?.kilometraje.toString() ?? '')
      ..addListener(_marcarModificado);
  }

  @override
  void dispose() {
    _marca.dispose();
    _modelo.dispose();
    _anio.dispose();
    _patente.dispose();
    _kilometraje.dispose();
    super.dispose();
  }

  void _marcarModificado() {
    if (!_modificado) setState(() => _modificado = true);
  }

  Future<void> _confirmarSalida() async {
    final confirmado = await dialogoConfirmacion(
      context,
      titulo: 'Descartar cambios',
      cuerpo: 'Hay cambios sin guardar. Si salís ahora se van a perder.',
      etiquetaConfirmar: 'Descartar',
      destructivo: true,
    );
    if (confirmado && mounted) context.pop();
  }

  Future<void> _guardar() async {
    if (!_claveFormulario.currentState!.validate()) return;

    setState(() => _guardando = true);

    final repositorio = ref.read(repositorioVehiculosProvider);
    final datos = Vehiculo(
      marca: _marca.text.trim(),
      modelo: _modelo.text.trim(),
      anio: int.parse(_anio.text.trim()),
      patente: _patente.text.trim().toUpperCase(),
      kilometraje: int.parse(_kilometraje.text.trim()),
      clienteId: widget.clienteId,
    );

    try {
      if (_esEdicion) {
        await repositorio.reemplazar(widget.vehiculo!.id!, datos);
      } else {
        await repositorio.crear(datos);
      }
      ref.invalidate(vehiculosPorClienteProvider(widget.clienteId));
      if (!mounted) return;
      _modificado = false;
      context.pop();
    } catch (error) {
      if (!mounted) return;
      setState(() => _guardando = false);
      Notificador.error(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final boton = BotonPrimario(
      etiqueta: 'Guardar',
      etiquetaCargando: 'Guardando...',
      cargando: _guardando,
      icono: Icons.save,
      onPressed: _guardar,
    );
    final esCompacto = context.esCompacto;

    return PopScope<Object?>(
      canPop: !_modificado,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _confirmarSalida();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_esEdicion ? 'Editar vehículo' : 'Nuevo vehículo'),
        ),
        body: ContenedorFormulario(
          child: Form(
            key: _claveFormulario,
            child: ListView(
              padding: EdgeInsets.all(context.bordePantalla),
              children: [
                SeccionFormulario(
                  campos: [
                    CampoTexto(
                      controller: _marca,
                      etiqueta: 'Marca',
                      capitalizacion: TextCapitalization.words,
                      validador: (valor) => Validadores.obligatorio(valor, etiqueta: 'La marca'),
                    ),
                    CampoTexto(
                      controller: _modelo,
                      etiqueta: 'Modelo',
                      capitalizacion: TextCapitalization.words,
                      validador: (valor) => Validadores.obligatorio(valor, etiqueta: 'El modelo'),
                    ),
                    CampoNumerico(
                      controller: _anio,
                      etiqueta: 'Año',
                      minimo: 1900,
                      maximo: 2100,
                    ),
                    CampoPatente(controller: _patente),
                    CampoNumerico(
                      controller: _kilometraje,
                      etiqueta: 'Kilometraje',
                      minimo: 0,
                      maximo: 9999999,
                    ),
                  ],
                ),
                if (!esCompacto) ...[
                  SizedBox(height: context.espaciado.xl),
                  boton,
                ],
              ],
            ),
          ),
        ),
        bottomNavigationBar: esCompacto ? BarraInferiorAcciones(child: boton) : null,
      ),
    );
  }
}
