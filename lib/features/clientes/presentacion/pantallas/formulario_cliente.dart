import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/layout/contexto_layout.dart';
import '../../../../core/red/excepciones.dart';
import '../../../../core/utilidades/validadores.dart';
import '../../../../shared/shared.dart';
import '../../dominio/cliente.dart';
import '../proveedores/clientes_proveedores.dart';

class FormularioCliente extends ConsumerStatefulWidget {
  final Cliente? cliente;

  const FormularioCliente({super.key, this.cliente});

  @override
  ConsumerState<FormularioCliente> createState() => _FormularioClienteState();
}

class _FormularioClienteState extends ConsumerState<FormularioCliente> {
  final _claveFormulario = GlobalKey<FormState>();
  late final TextEditingController _nombre;
  late final TextEditingController _contacto;
  bool _guardando = false;
  bool _modificado = false;

  bool get _esEdicion => widget.cliente != null;

  @override
  void initState() {
    super.initState();
    _nombre = TextEditingController(text: widget.cliente?.nombre ?? '')
      ..addListener(_marcarModificado);
    _contacto = TextEditingController(text: widget.cliente?.contacto ?? '')
      ..addListener(_marcarModificado);
  }

  @override
  void dispose() {
    _nombre.dispose();
    _contacto.dispose();
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

    final repositorio = ref.read(repositorioClientesProvider);
    final datos = Cliente(
      nombre: _nombre.text.trim(),
      contacto: _contacto.text.trim().isEmpty ? null : _contacto.text.trim(),
    );

    try {
      if (_esEdicion) {
        await repositorio.reemplazar(widget.cliente!.id!, datos);
      } else {
        await repositorio.crear(datos);
      }
      ref.invalidate(clientesProvider);
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
          title: Text(_esEdicion ? 'Editar cliente' : 'Nuevo cliente'),
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
                      controller: _nombre,
                      etiqueta: 'Nombre',
                      capitalizacion: TextCapitalization.words,
                      validador: Validadores.combinar([
                        (valor) => Validadores.obligatorio(valor, etiqueta: 'El nombre'),
                        (valor) => Validadores.largoMaximo(valor, 100),
                      ]),
                    ),
                    CampoTexto(
                      controller: _contacto,
                      etiqueta: 'Contacto',
                      validador: (valor) => Validadores.largoMaximo(valor, 100),
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
