import 'package:flutter/material.dart';

import '../../extensiones/elevacion_tema.dart';
import '../../tokens/tokens.dart';

AppBarThemeData appBarTema(ColorScheme esquema, ElevacionTema elevacion) {
  return AppBarThemeData(
    elevation: 0,
    scrolledUnderElevation: 0,
    backgroundColor: esquema.surface,
    foregroundColor: esquema.onSurface,
    surfaceTintColor: Colors.transparent,
    titleTextStyle: Tipografia.titleLg.copyWith(color: esquema.onSurface),
    shape: Border(
      bottom: BorderSide(
        color: elevacion.n1.colorBorde,
        width: elevacion.n1.anchoBorde,
      ),
    ),
  );
}

/// Usado en el breakpoint compacto (F7).
NavigationBarThemeData navigationBarTema(ColorScheme esquema) {
  return NavigationBarThemeData(
    backgroundColor: esquema.surfaceContainerLowest,
    indicatorColor: esquema.primaryContainer,
    labelTextStyle: const WidgetStatePropertyAll(Tipografia.labelMd),
  );
}

/// Usado en los breakpoints medio y expandido (F7).
NavigationRailThemeData navigationRailTema(ColorScheme esquema) {
  return NavigationRailThemeData(
    backgroundColor: esquema.surfaceContainerLowest,
    indicatorColor: esquema.primaryContainer,
    selectedIconTheme: IconThemeData(color: esquema.primary),
    unselectedIconTheme: IconThemeData(color: esquema.onSurfaceVariant),
    selectedLabelTextStyle: Tipografia.labelMd.copyWith(color: esquema.onSurface),
    unselectedLabelTextStyle: Tipografia.labelMd.copyWith(
      color: esquema.onSurfaceVariant,
    ),
  );
}
