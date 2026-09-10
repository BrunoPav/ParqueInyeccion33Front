import 'package:flutter/painting.dart';

/// Familias tipográficas del design-system. Los pesos disponibles están
/// declarados en `pubspec.yaml` y los archivos viven en `assets/fuentes/`.
abstract final class FamiliaFuente {
  static const String inter = 'Inter';
  static const String jetBrainsMono = 'JetBrains Mono';
}

/// Escala tipográfica completa, sin color (el color lo aporta el tema).
///
/// El único valor especificado en DESIGN.md es [headlineLg]. El resto de la
/// escala está **derivado** guardando la misma progresión de tamaño/peso de
/// Material 3; se revisa contra los mockups en F9.
abstract final class Tipografia {
  static const TextStyle headlineLg = TextStyle(
    fontFamily: FamiliaFuente.inter,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 40 / 32,
    letterSpacing: -0.64,
  );

  static const TextStyle titleLg = TextStyle(
    fontFamily: FamiliaFuente.inter,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 28 / 22,
  );

  static const TextStyle titleMd = TextStyle(
    fontFamily: FamiliaFuente.inter,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 24 / 16,
  );

  static const TextStyle bodyLg = TextStyle(
    fontFamily: FamiliaFuente.inter,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  );

  static const TextStyle bodyMd = TextStyle(
    fontFamily: FamiliaFuente.inter,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
  );

  static const TextStyle bodySm = TextStyle(
    fontFamily: FamiliaFuente.inter,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
  );

  static const TextStyle labelLg = TextStyle(
    fontFamily: FamiliaFuente.inter,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
  );

  static const TextStyle labelMd = TextStyle(
    fontFamily: FamiliaFuente.inter,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 16 / 12,
    letterSpacing: 0.4,
  );

  static const TextStyle labelSm = TextStyle(
    fontFamily: FamiliaFuente.inter,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 16 / 11,
  );

  /// Patentes y VIN: JetBrains Mono, tracking abierto para distinguir `0`/`O`
  /// y `1`/`I`. El texto en sí lo pasa el widget consumidor en mayúsculas.
  static const TextStyle labelMono = TextStyle(
    fontFamily: FamiliaFuente.jetBrainsMono,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    letterSpacing: 0.5,
  );
}

/// Aplica cifras tabulares a cualquier [TextStyle] de la escala, para
/// odómetros, horas de mano de obra, montos y demás valores numéricos que no
/// deben "bailar" al alinearse en columna.
extension CifrasTabulares on TextStyle {
  TextStyle get conCifrasTabulares {
    return copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
  }
}
