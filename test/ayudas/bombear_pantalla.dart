import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/misc.dart' show Override;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taller_mecanico_frontend/core/design_system/design_system.dart';
import 'package:taller_mecanico_frontend/features/ajustes/datos/preferencias.dart';

/// Monta una sola pantalla dentro de un [ProviderScope] y un [MaterialApp],
/// sin depender de `AplicacionTaller` ni de `main.dart`.
///
/// Usar `overrides` para reemplazar los providers de datos por dobles de
/// prueba, y `tema` para probar contra un [ThemeData] distinto al claro por
/// defecto — cualquier pantalla que use `context.colores`/`context.espaciado`
/// (vía `ContextoTema`) necesita sus `ThemeExtension` registradas.
///
/// Pasar `enrutador` en vez de `pantalla` cuando el test necesita que
/// `context.push`/`context.pop` funcionen de verdad (un `GoRouter` de
/// prueba), en vez de un `MaterialApp` sin router.
Future<void> bombearPantalla(
  WidgetTester tester,
  Widget? pantalla, {
  List<Override> overrides = const [],
  ThemeData? tema,
  GoRouter? enrutador,
}) async {
  assert(
    (pantalla == null) != (enrutador == null),
    'bombearPantalla necesita pantalla O enrutador, no los dos ni ninguno.',
  );

  final temaResuelto = tema ?? temaPrecision(const PaletaPrecisionClara(), Brightness.light);

  // preferenciasProvider explota si no se sobrescribe, y desde que la barra de
  // navegacion lee la sesion lo necesita cualquier pantalla, no solo Ajustes.
  // Va primero para que un override del test lo pise si hace falta.
  SharedPreferences.setMockInitialValues({});
  final preferencias = await SharedPreferences.getInstance();

  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        preferenciasProvider.overrideWithValue(preferencias),
        ...overrides,
      ],
      retry: (_, _) => null,
      child: enrutador != null
          ? MaterialApp.router(theme: temaResuelto, routerConfig: enrutador)
          : MaterialApp(theme: temaResuelto, home: pantalla),
    ),
  );
}
