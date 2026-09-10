import 'package:flutter/painting.dart';

/// Escala de radios en bruto. Las pantallas no deberían usar esta clase
/// directamente: usan los alias semánticos de [RadiosTaller].
abstract final class Radios {
  static const double xs = 2;
  static const double sm = 4;
  static const double md = 6;
  static const double lg = 8;
  static const double xl = 12;
  static const double completo = 9999;
}

/// Alias semánticos de radio, ya como [BorderRadius], como los fija la
/// sección "Shapes" de DESIGN.md.
abstract final class RadiosTaller {
  static const BorderRadius chip = BorderRadius.all(Radius.circular(Radios.sm));
  static const BorderRadius tarjeta = BorderRadius.all(Radius.circular(Radios.lg));
  static const BorderRadius boton = BorderRadius.all(Radius.circular(Radios.lg));
  static const BorderRadius entrada = BorderRadius.all(Radius.circular(Radios.lg));
  static const BorderRadius contenedor = BorderRadius.all(Radius.circular(Radios.xl));
  static const BorderRadius completo = BorderRadius.all(Radius.circular(Radios.completo));
}
