import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/misc.dart' show Override;
import 'package:taller_mecanico_frontend/core/design_system/design_system.dart';

/// Monta una sola pantalla dentro de un [ProviderScope] y un [MaterialApp],
/// sin depender de `AplicacionTaller` ni de `main.dart`.
///
/// Usar `overrides` para reemplazar los providers de datos por dobles de
/// prueba, y `tema` para probar contra un [ThemeData] distinto al claro por
/// defecto — cualquier pantalla que use `context.colores`/`context.espaciado`
/// (vía `ContextoTema`) necesita sus `ThemeExtension` registradas.
Future<void> bombearPantalla(
  WidgetTester tester,
  Widget pantalla, {
  List<Override> overrides = const [],
  ThemeData? tema,
}) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: tema ?? temaPrecision(const PaletaPrecisionClara(), Brightness.light),
        home: pantalla,
      ),
    ),
  );
}
