import 'package:flutter/material.dart';

import '../../tokens/tokens.dart';

const ButtonStyle _estiloBase = ButtonStyle(
  shape: WidgetStatePropertyAll(
    RoundedRectangleBorder(borderRadius: RadiosTaller.boton),
  ),
  textStyle: WidgetStatePropertyAll(Tipografia.labelLg),
  padding: WidgetStatePropertyAll(
    EdgeInsets.symmetric(horizontal: Espaciado.lg),
  ),
);

FilledButtonThemeData filledButtonTema(ColorScheme esquema) {
  return FilledButtonThemeData(
    style: _estiloBase.copyWith(
      backgroundColor: WidgetStatePropertyAll(esquema.primary),
      foregroundColor: WidgetStatePropertyAll(esquema.onPrimary),
      minimumSize: const WidgetStatePropertyAll(
        Size.fromHeight(Dimensiones.botonPrimario),
      ),
    ),
  );
}

ElevatedButtonThemeData elevatedButtonTema(ColorScheme esquema) {
  return ElevatedButtonThemeData(
    style: _estiloBase.copyWith(
      elevation: const WidgetStatePropertyAll(0),
      backgroundColor: WidgetStatePropertyAll(esquema.primary),
      foregroundColor: WidgetStatePropertyAll(esquema.onPrimary),
      minimumSize: const WidgetStatePropertyAll(
        Size.fromHeight(Dimensiones.botonPrimario),
      ),
    ),
  );
}

OutlinedButtonThemeData outlinedButtonTema(ColorScheme esquema) {
  return OutlinedButtonThemeData(
    style: _estiloBase.copyWith(
      foregroundColor: WidgetStatePropertyAll(esquema.onSurface),
      side: WidgetStatePropertyAll(BorderSide(color: esquema.outline)),
      minimumSize: const WidgetStatePropertyAll(
        Size.fromHeight(Dimensiones.botonSecundario),
      ),
    ),
  );
}

TextButtonThemeData textButtonTema(ColorScheme esquema) {
  return TextButtonThemeData(
    style: _estiloBase.copyWith(
      foregroundColor: WidgetStatePropertyAll(esquema.primary),
      minimumSize: const WidgetStatePropertyAll(
        Size(0, Dimensiones.botonSecundario),
      ),
    ),
  );
}
