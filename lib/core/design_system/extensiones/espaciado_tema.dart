import 'package:flutter/material.dart';

import '../tokens/espaciado.dart';

/// Expone la escala de [Espaciado] vía tema, para que un widget nunca
/// importe el token directo. Los valores no varían por brillo; existe como
/// `ThemeExtension` para que el acceso sea siempre `context.espaciado.md`,
/// igual que `context.colores` o `context.estados`.
class EspaciadoTema extends ThemeExtension<EspaciadoTema> {
  final double xxs;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  final double bordePantallaMovil;
  final double bordePantallaTablet;
  final double separacionLista;
  final double objetivoTactil;
  final double objetivoTactilAmplio;

  const EspaciadoTema({
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.bordePantallaMovil,
    required this.bordePantallaTablet,
    required this.separacionLista,
    required this.objetivoTactil,
    required this.objetivoTactilAmplio,
  });

  factory EspaciadoTema.delToken() {
    return const EspaciadoTema(
      xxs: Espaciado.xxs,
      xs: Espaciado.xs,
      sm: Espaciado.sm,
      md: Espaciado.md,
      lg: Espaciado.lg,
      xl: Espaciado.xl,
      xxl: Espaciado.xxl,
      bordePantallaMovil: Espaciado.bordePantallaMovil,
      bordePantallaTablet: Espaciado.bordePantallaTablet,
      separacionLista: Espaciado.separacionLista,
      objetivoTactil: Espaciado.objetivoTactil,
      objetivoTactilAmplio: Espaciado.objetivoTactilAmplio,
    );
  }

  @override
  EspaciadoTema copyWith({
    double? xxs,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? bordePantallaMovil,
    double? bordePantallaTablet,
    double? separacionLista,
    double? objetivoTactil,
    double? objetivoTactilAmplio,
  }) {
    return EspaciadoTema(
      xxs: xxs ?? this.xxs,
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      bordePantallaMovil: bordePantallaMovil ?? this.bordePantallaMovil,
      bordePantallaTablet: bordePantallaTablet ?? this.bordePantallaTablet,
      separacionLista: separacionLista ?? this.separacionLista,
      objetivoTactil: objetivoTactil ?? this.objetivoTactil,
      objetivoTactilAmplio: objetivoTactilAmplio ?? this.objetivoTactilAmplio,
    );
  }

  @override
  EspaciadoTema lerp(ThemeExtension<EspaciadoTema>? other, double t) {
    if (other is! EspaciadoTema) return this;
    return EspaciadoTema(
      xxs: lerpDouble(xxs, other.xxs, t),
      xs: lerpDouble(xs, other.xs, t),
      sm: lerpDouble(sm, other.sm, t),
      md: lerpDouble(md, other.md, t),
      lg: lerpDouble(lg, other.lg, t),
      xl: lerpDouble(xl, other.xl, t),
      xxl: lerpDouble(xxl, other.xxl, t),
      bordePantallaMovil: lerpDouble(bordePantallaMovil, other.bordePantallaMovil, t),
      bordePantallaTablet: lerpDouble(bordePantallaTablet, other.bordePantallaTablet, t),
      separacionLista: lerpDouble(separacionLista, other.separacionLista, t),
      objetivoTactil: lerpDouble(objetivoTactil, other.objetivoTactil, t),
      objetivoTactilAmplio: lerpDouble(objetivoTactilAmplio, other.objetivoTactilAmplio, t),
    );
  }

  static double lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
