import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/layout/contexto_layout.dart';
import '../../../../core/red/excepciones.dart';
import '../../../../core/utilidades/validadores.dart';
import '../../../../shared/shared.dart';
import '../../dominio/servicio.dart';
import '../proveedores/servicios_proveedores.dart';

class FormularioServicio extends ConsumerStatefulWidget {
  final int vehiculoId;
  final Servicio? servicio;

  const FormularioServicio({
    super.key,
    required this.vehiculoId,
    this.servicio,
  });

  @override
  ConsumerState<FormularioServicio> createState() => _FormularioServicioState();
}

class _FormularioServicioState extends ConsumerState<FormularioServicio> {
  final _claveFormulario = GlobalKey<FormState>();
  late final TextEditingController _descripcion;
  late final TextEditingController _precio;
  late DateTime _fecha;
  bool _guardando = false;
  bool _modificado = false;

  bool get _esEdicion => widget.servicio != null;

  @override
  void initState() {
    super.initState();
    final s = widget.servicio;
    _descripcion = TextEditingController(text: s?.descripcion ?? '')
      ..addListener(_marcarModificado);
    _precio = TextEditingController(text: s?.precio.toStringAsFixed(2) ?? '')
      ..addListener(_marcarModificado);
    _fecha = s?.fecha ?? DateTime.now();
  }

  @override
  void dispose() {
    _descripcion.dispose();
    _precio.dispose();
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

    final repositorio = ref.read(repositorioServiciosProvider);
    final datos = Servicio(
      fecha: _fecha,
      descripcion: _descripcion.text.trim(),
      precio: CampoMoneda.parsear(_precio.text),
      vehiculoId: widget.vehiculoId,
    );

    try {
      if (_esEdicion) {
        await repositorio.reemplazar(widget.servicio!.id!, datos);
      } else {
        await repositorio.crear(datos);
      }
      ref.invalidate(serviciosPorVehiculoProvider(widget.vehiculoId));
      if (!mounted) return;
      _modificado = false;
      context.pop();
    } catch (error) {
      if (!mounted) return;
      setState(() => _guardando = false);
      Notificador.error(context, mensajeDeError(error));
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
          title: Text(_esEdicion ? 'Editar servicio' : 'Nuevo servicio'),
        ),
        body: ContenedorFormulario(
          child: Form(
            key: _claveFormulario,
            child: ListView(
              padding: EdgeInsets.all(context.bordePantalla),
              children: [
                SeccionFormulario(
                  campos: [
                    CampoFecha(
                      etiqueta: 'Fecha',
                      valor: _fecha,
                      onCambiar: (elegida) {
                        _marcarModificado();
                        setState(() => _fecha = elegida);
                      },
                    ),
                    CampoTexto(
                      controller: _descripcion,
                      etiqueta: 'Descripción',
                      maxLineas: 4,
                      capitalizacion: TextCapitalization.sentences,
                      validador: Validadores.combinar([
                        (valor) => Validadores.obligatorio(valor, etiqueta: 'La descripción'),
                        (valor) => Validadores.largoMaximo(valor, 2000),
                      ]),
                    ),
                    CampoMoneda(controller: _precio),
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
