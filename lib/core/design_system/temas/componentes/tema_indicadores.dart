import 'package:flutter/material.dart';

import '../../tokens/tokens.dart';

/// Cubre `Chip` y sus variantes (`FilterChip` incluido: Flutter no tiene un
/// tema separado para cada variante).
ChipThemeData chipTema(ColorScheme esquema) {
  return ChipThemeData(
    backgroundColor: esquema.surfaceContainerHigh,
    selectedColor: esquema.primary,
    disabledColor: esquema.surfaceContainerHighest,
    labelStyle: Tipografia.labelMd,
    secondaryLabelStyle: Tipografia.labelMd.copyWith(color: esquema.onPrimary),
    padding: PaddingTaller.chip,
    labelPadding: EdgeInsets.zero,
    side: BorderSide(color: esquema.outlineVariant),
    shape: const RoundedRectangleBorder(borderRadius: RadiosTaller.chip),
  );
}
