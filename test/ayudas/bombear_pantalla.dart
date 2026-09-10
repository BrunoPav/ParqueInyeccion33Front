import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/misc.dart' show Override;

/// Monta una sola pantalla dentro de un [ProviderScope] y un [MaterialApp],
/// sin depender de `AplicacionTaller` ni de `main.dart`.
///
/// Usar `overrides` para reemplazar los providers de datos por dobles de
/// prueba, y `tema` cuando el test necesite verificar algo contra el
/// [ThemeData] real de la app.
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
        theme: tema,
        home: pantalla,
      ),
    ),
  );
}
