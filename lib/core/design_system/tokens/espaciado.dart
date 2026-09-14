import 'package:flutter/painting.dart';

/// Escala de espaciado, 1:1 con el frontmatter de DESIGN.md.
abstract final class Espaciado {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;

  static const double bordePantallaMovil = 16;
  static const double bordePantallaTablet = 24;
  static const double separacionLista = 12;

  static const double objetivoTactil = 48;
  static const double objetivoTactilAmplio = 56;
}

abstract final class PaddingTaller {
  static const EdgeInsets tarjeta = EdgeInsets.all(Espaciado.md);

  static const EdgeInsets chip = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: Espaciado.xxs,
  );

  static const EdgeInsets pantallaMovil = EdgeInsets.symmetric(
    horizontal: Espaciado.bordePantallaMovil,
  );

  static const EdgeInsets pantallaTablet = EdgeInsets.symmetric(
    horizontal: Espaciado.bordePantallaTablet,
  );
}
