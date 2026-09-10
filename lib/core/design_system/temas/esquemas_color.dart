import 'package:flutter/material.dart';

import '../tokens/paleta.dart';

/// Arma un [ColorScheme] completo a partir de una [Paleta], para el brillo
/// dado. Cualquier paleta nueva del catálogo pasa por acá: no hace falta
/// escribir un mapeo por tema.
ColorScheme esquemaColorDesdePaleta(Paleta paleta, Brightness brillo) {
  return ColorScheme(
    brightness: brillo,
    primary: paleta.primario,
    onPrimary: paleta.onPrimario,
    primaryContainer: paleta.primarioContenedor,
    onPrimaryContainer: paleta.onPrimarioContenedor,
    secondary: paleta.secundario,
    onSecondary: paleta.onSecundario,
    secondaryContainer: paleta.secundarioContenedor,
    onSecondaryContainer: paleta.onSecundarioContenedor,
    tertiary: paleta.terciario,
    onTertiary: paleta.onTerciario,
    tertiaryContainer: paleta.terciarioContenedor,
    onTertiaryContainer: paleta.onTerciarioContenedor,
    error: paleta.error,
    onError: paleta.onError,
    errorContainer: paleta.errorContenedor,
    onErrorContainer: paleta.onErrorContenedor,
    surface: paleta.superficie,
    onSurface: paleta.onSuperficie,
    surfaceContainerLowest: paleta.superficieContenedorMasBaja,
    surfaceContainerLow: paleta.superficieContenedorBaja,
    surfaceContainer: paleta.superficieContenedor,
    surfaceContainerHigh: paleta.superficieContenedorAlta,
    surfaceContainerHighest: paleta.superficieContenedorMasAlta,
    onSurfaceVariant: paleta.onSuperficieVariante,
    outline: paleta.contorno,
    outlineVariant: paleta.contornoVariante,
    shadow: paleta.sombra,
    scrim: paleta.scrim,
    inverseSurface: paleta.superficieInversa,
    onInverseSurface: paleta.onSuperficieInversa,
    inversePrimary: paleta.primarioInverso,
    surfaceTint: paleta.tinteSuperficie,
  );
}
