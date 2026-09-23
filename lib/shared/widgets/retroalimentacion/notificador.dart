import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/red/excepciones.dart';
import '../../../core/routing/rutas.dart';

/// Un solo punto para los `SnackBar` de error y de éxito.
abstract final class Notificador {
  /// Muestra un error de la API y, si lo que falta son credenciales, ofrece ir
  /// al login ahí mismo: decir "iniciá sesión" sin llevar a ningún lado deja al
  /// usuario con el problema y sin la salida.
  static void errorDeApi(BuildContext context, Object error) {
    final necesitaSesion = requiereSesion(error);
    Notificador.error(
      context,
      mensajeDeError(error),
      etiquetaAccion: necesitaSesion ? 'Iniciar sesión' : null,
      alAccionar: necesitaSesion ? () => context.go(Rutas.login) : null,
    );
  }

  static void error(
    BuildContext context,
    String mensaje, {
    String? etiquetaAccion,
    VoidCallback? alAccionar,
  }) {
    final colores = context.colores;
    _mostrar(
      context,
      mensaje,
      fondo: colores.error,
      texto: colores.onError,
      etiquetaAccion: etiquetaAccion,
      alAccionar: alAccionar,
    );
  }

  static void exito(BuildContext context, String mensaje) {
    final tono = context.estados.exito;
    _mostrar(context, mensaje, fondo: tono.fondo, texto: tono.texto);
  }

  static void _mostrar(
    BuildContext context,
    String mensaje, {
    required Color fondo,
    required Color texto,
    String? etiquetaAccion,
    VoidCallback? alAccionar,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje, style: TextStyle(color: texto)),
        backgroundColor: fondo,
        action: (etiquetaAccion == null || alAccionar == null)
            ? null
            : SnackBarAction(
                label: etiquetaAccion,
                textColor: texto,
                onPressed: alAccionar,
              ),
      ),
    );
  }
}
