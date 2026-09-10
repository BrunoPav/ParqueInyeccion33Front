import 'package:flutter/material.dart';

import '../../extensiones/elevacion_tema.dart';
import '../../tokens/tokens.dart';

/// Solo cubre el `Card` de stock, que no soporta una lista de [BoxShadow]
/// arbitraria (el modelo de elevación de Material es un único número). La
/// sombra real de [Elevacion] la aplica `TarjetaTaller`, el widget
/// compartido de F4, directamente sobre un `Container`.
CardThemeData cardTema(ColorScheme esquema, ElevacionTema elevacion) {
  return CardThemeData(
    color: esquema.surfaceContainerLowest,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: RadiosTaller.tarjeta,
      side: BorderSide(
        color: elevacion.n1.colorBorde,
        width: elevacion.n1.anchoBorde,
      ),
    ),
  );
}
