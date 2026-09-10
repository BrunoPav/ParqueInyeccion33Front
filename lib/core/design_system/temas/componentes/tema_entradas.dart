import 'package:flutter/material.dart';

import '../../tokens/tokens.dart';

OutlineInputBorder _borde(Color color, double ancho) {
  return OutlineInputBorder(
    borderRadius: RadiosTaller.entrada,
    borderSide: BorderSide(color: color, width: ancho),
  );
}

/// El foco desplaza el borde a `primary` y lo engrosa a
/// [Dimensiones.anchoBordeEntradaFoco] — la aproximación de tema al "anillo
/// concéntrico" de DESIGN.md. Un anillo literal por fuera del campo queda
/// para el widget `CampoTexto` de `/shared` (F4), si hace falta ese detalle.
InputDecorationThemeData inputDecorationTema(ColorScheme esquema) {
  return InputDecorationThemeData(
    filled: true,
    fillColor: esquema.surfaceContainerLowest,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: Espaciado.md,
      vertical: Espaciado.sm,
    ),
    border: _borde(esquema.outline, Dimensiones.anchoBordeEntrada),
    enabledBorder: _borde(esquema.outline, Dimensiones.anchoBordeEntrada),
    focusedBorder: _borde(esquema.primary, Dimensiones.anchoBordeEntradaFoco),
    errorBorder: _borde(esquema.error, Dimensiones.anchoBordeEntrada),
    focusedErrorBorder: _borde(esquema.error, Dimensiones.anchoBordeEntradaFoco),
    disabledBorder: _borde(esquema.outlineVariant, Dimensiones.anchoBordeEntrada),
    labelStyle: Tipografia.bodyMd,
    hintStyle: Tipografia.bodyMd,
    errorStyle: Tipografia.bodySm,
    isDense: true,
  );
}
