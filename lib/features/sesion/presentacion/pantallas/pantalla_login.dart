import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/layout/contexto_layout.dart';
import '../../../../core/red/excepciones.dart';
import '../../../../core/routing/rutas.dart';
import '../../../../core/utilidades/validadores.dart';
import '../../../../shared/shared.dart';
import '../proveedores/sesion_proveedores.dart';

class PantallaLogin extends ConsumerStatefulWidget {
  const PantallaLogin({super.key});

  @override
  ConsumerState<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends ConsumerState<PantallaLogin> {
  final _claveFormulario = GlobalKey<FormState>();
  final _usuario = TextEditingController();
  final _contrasena = TextEditingController();
  bool _entrando = false;
  bool _ocultarContrasena = true;

  @override
  void dispose() {
    _usuario.dispose();
    _contrasena.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!_claveFormulario.currentState!.validate()) return;

    setState(() => _entrando = true);

    try {
      await ref.read(sesionProvider.notifier).iniciarSesion(
            _usuario.text.trim(),
            _contrasena.text,
          );
      if (!mounted) return;
      context.go(Rutas.clientes);
    } on ExcepcionApi catch (error) {
      if (!mounted) return;
      setState(() => _entrando = false);
      Notificador.error(
        context,
        error.status == 401 ? 'Usuario o contraseña incorrectos' : error.mensaje,
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _entrando = false);
      Notificador.error(context, error.toString());
    }
  }

  void _completarDemo() {
    _usuario.text = 'demo';
    _contrasena.text = 'demo1234';
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final espaciado = context.espaciado;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(context.bordePantalla),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _claveFormulario,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: espaciado.xl),
                    child: Image.asset(
                      'assets/imagenes/parque-inyeccion.png',
                      height: 84,
                      fit: BoxFit.contain,
                      semanticLabel: 'Parque Inyección',
                    ),
                  ),
                  Text(
                    'Historial de taller',
                    textAlign: TextAlign.center,
                    style: tema.textTheme.titleMedium,
                  ),
                  SizedBox(height: espaciado.xs),
                  Text(
                    'Iniciá sesión para crear o editar registros.',
                    textAlign: TextAlign.center,
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: tema.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: espaciado.xl),
                  SeccionFormulario(
                    campos: [
                      CampoTexto(
                        controller: _usuario,
                        etiqueta: 'Usuario',
                        validador: (valor) =>
                            Validadores.obligatorio(valor, etiqueta: 'El usuario'),
                      ),
                      CampoTexto(
                        controller: _contrasena,
                        etiqueta: 'Contraseña',
                        ocultarTexto: _ocultarContrasena,
                        sufijo: IconButton(
                          icon: Icon(
                            _ocultarContrasena
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          tooltip: _ocultarContrasena ? 'Mostrar' : 'Ocultar',
                          onPressed: () => setState(
                            () => _ocultarContrasena = !_ocultarContrasena,
                          ),
                        ),
                        validador: (valor) =>
                            Validadores.obligatorio(valor, etiqueta: 'La contraseña'),
                      ),
                    ],
                  ),
                  SizedBox(height: espaciado.xl),
                  BotonPrimario(
                    etiqueta: 'Entrar',
                    etiquetaCargando: 'Entrando...',
                    cargando: _entrando,
                    icono: Icons.login,
                    onPressed: _entrar,
                  ),
                  SizedBox(height: espaciado.md),
                  TextButton(
                    onPressed: _entrando ? null : _completarDemo,
                    child: const Text('Usar credenciales de demostración'),
                  ),
                  SizedBox(height: espaciado.lg),
                  TextButton.icon(
                    onPressed: _entrando ? null : () => context.go(Rutas.clientes),
                    icon: const Icon(Icons.visibility_outlined, size: 18),
                    label: const Text('Entrar sin iniciar sesión (solo lectura)'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
