import 'package:flutter/material.dart';

import '../extensiones/colores_estado.dart';
import '../extensiones/elevacion_tema.dart';
import '../extensiones/espaciado_tema.dart';
import '../tokens/paleta.dart';
import '../tokens/tipografia.dart';
import 'componentes/tema_botones.dart';
import 'componentes/tema_entradas.dart';
import 'componentes/tema_indicadores.dart';
import 'componentes/tema_navegacion.dart';
import 'componentes/tema_superficies.dart';
import 'componentes/tema_varios.dart';
import 'esquemas_color.dart';

/// La escala de [Tipografia], sin color, mapeada a los 15 slots de
/// [TextTheme]. Nuestra escala solo tiene 9 estilos con nombre; los slots
/// "display" y "headline-small/medium" de Material, que la app no usa hoy,
/// quedan como alias de los estilos más cercanos en tamaño.
const TextTheme _textThemeBase = TextTheme(
  displayLarge: Tipografia.headlineLg,
  displayMedium: Tipografia.headlineLg,
  displaySmall: Tipografia.headlineLg,
  headlineLarge: Tipografia.headlineLg,
  headlineMedium: Tipografia.titleLg,
  headlineSmall: Tipografia.titleLg,
  titleLarge: Tipografia.titleLg,
  titleMedium: Tipografia.titleMd,
  titleSmall: Tipografia.bodyLg,
  bodyLarge: Tipografia.bodyLg,
  bodyMedium: Tipografia.bodyMd,
  bodySmall: Tipografia.bodySm,
  labelLarge: Tipografia.labelLg,
  labelMedium: Tipografia.labelMd,
  labelSmall: Tipografia.labelSm,
);

/// Arma el `ThemeData` completo del tema "Precision Workshop" para el
/// [brillo] dado, a partir de una [Paleta]. Cualquier tema del catálogo
/// (F2.17) se construye llamando a esta misma función con su propia paleta.
ThemeData temaPrecision(Paleta paleta, Brightness brillo) {
  final esquema = esquemaColorDesdePaleta(paleta, brillo);
  final elevacion = ElevacionTema.desdePaleta(paleta, brillo);
  final textTheme = _textThemeBase.apply(
    bodyColor: esquema.onSurface,
    displayColor: esquema.onSurface,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brillo,
    colorScheme: esquema,
    scaffoldBackgroundColor: esquema.surface,
    textTheme: textTheme,
    appBarTheme: appBarTema(esquema, elevacion),
    cardTheme: cardTema(esquema, elevacion),
    chipTheme: chipTema(esquema),
    dialogTheme: dialogTema(esquema),
    dividerTheme: dividerTema(esquema),
    elevatedButtonTheme: elevatedButtonTema(esquema),
    filledButtonTheme: filledButtonTema(esquema),
    floatingActionButtonTheme: floatingActionButtonTema(esquema),
    inputDecorationTheme: inputDecorationTema(esquema),
    listTileTheme: listTileTema(esquema),
    navigationBarTheme: navigationBarTema(esquema),
    navigationRailTheme: navigationRailTema(esquema),
    outlinedButtonTheme: outlinedButtonTema(esquema),
    popupMenuTheme: popupMenuTema(esquema),
    snackBarTheme: snackBarTema(esquema),
    textButtonTheme: textButtonTema(esquema),
    extensions: [
      ColoresEstado.desdePaleta(paleta),
      EspaciadoTema.delToken(),
      elevacion,
    ],
  );
}
