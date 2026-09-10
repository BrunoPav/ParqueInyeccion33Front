import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taller_mecanico_frontend/core/design_system/design_system.dart';
import 'package:taller_mecanico_frontend/core/design_system/galeria_tokens.dart';

import '../../ayudas/bombear_pantalla.dart';

void main() {
  testWidgets('la galeria de tokens renderiza con el tema claro', (tester) async {
    await bombearPantalla(
      tester,
      const GaleriaTokens(),
      tema: temaPrecision(const PaletaPrecisionClara(), Brightness.light),
    );

    expect(find.text('Galería de tokens'), findsOneWidget);
    expect(find.text('Headline LG'), findsOneWidget);
  });

  testWidgets('la galeria de tokens renderiza con el tema oscuro', (tester) async {
    await bombearPantalla(
      tester,
      const GaleriaTokens(),
      tema: temaPrecision(const PaletaPrecisionOscura(), Brightness.dark),
    );

    expect(find.text('Galería de tokens'), findsOneWidget);
  });
}
