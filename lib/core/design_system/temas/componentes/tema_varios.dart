import 'package:flutter/material.dart';

import '../../tokens/tokens.dart';

DividerThemeData dividerTema(ColorScheme esquema) {
  return DividerThemeData(color: esquema.outlineVariant, thickness: 1, space: 1);
}

ListTileThemeData listTileTema(ColorScheme esquema) {
  return ListTileThemeData(
    textColor: esquema.onSurface,
    iconColor: esquema.onSurfaceVariant,
    titleTextStyle: Tipografia.titleMd.copyWith(color: esquema.onSurface),
    subtitleTextStyle: Tipografia.bodyMd.copyWith(color: esquema.onSurfaceVariant),
  );
}

SnackBarThemeData snackBarTema(ColorScheme esquema) {
  return SnackBarThemeData(
    backgroundColor: esquema.inverseSurface,
    contentTextStyle: Tipografia.bodyMd.copyWith(color: esquema.onInverseSurface),
    actionTextColor: esquema.inversePrimary,
    shape: const RoundedRectangleBorder(borderRadius: RadiosTaller.tarjeta),
    behavior: SnackBarBehavior.floating,
  );
}

DialogThemeData dialogTema(ColorScheme esquema) {
  return DialogThemeData(
    backgroundColor: esquema.surfaceContainerHigh,
    shape: const RoundedRectangleBorder(borderRadius: RadiosTaller.contenedor),
    titleTextStyle: Tipografia.titleLg.copyWith(color: esquema.onSurface),
    contentTextStyle: Tipografia.bodyMd.copyWith(color: esquema.onSurfaceVariant),
  );
}

PopupMenuThemeData popupMenuTema(ColorScheme esquema) {
  return PopupMenuThemeData(
    color: esquema.surfaceContainerHigh,
    textStyle: Tipografia.bodyMd.copyWith(color: esquema.onSurface),
    shape: const RoundedRectangleBorder(borderRadius: RadiosTaller.tarjeta),
  );
}

FloatingActionButtonThemeData floatingActionButtonTema(ColorScheme esquema) {
  return FloatingActionButtonThemeData(
    backgroundColor: esquema.primary,
    foregroundColor: esquema.onPrimary,
    shape: const RoundedRectangleBorder(borderRadius: RadiosTaller.boton),
  );
}
