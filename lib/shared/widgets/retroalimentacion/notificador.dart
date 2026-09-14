import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';

/// Un solo punto para los `SnackBar` de error y de éxito.
abstract final class Notificador {
  static void error(BuildContext context, String mensaje) {
    final colores = context.colores;
    _mostrar(context, mensaje, fondo: colores.error, texto: colores.onError);
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
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje, style: TextStyle(color: texto)),
        backgroundColor: fondo,
      ),
    );
  }
}
