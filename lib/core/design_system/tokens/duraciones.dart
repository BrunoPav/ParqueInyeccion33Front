import 'package:flutter/animation.dart';

/// Duraciones de transición: cambios de estado, apertura de diálogos,
/// navegación entre pantallas.
abstract final class Duraciones {
  static const Duration rapida = Duration(milliseconds: 120);
  static const Duration normal = Duration(milliseconds: 220);
  static const Duration lenta = Duration(milliseconds: 320);
}

/// Curvas de animación estándar de la app.
abstract final class CurvasTaller {
  static const Curve entrada = Curves.easeOut;
  static const Curve salida = Curves.easeIn;
  static const Curve enfasis = Curves.easeInOutCubicEmphasized;
}
