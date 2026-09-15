import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/misc.dart' show Override;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taller_mecanico_frontend/core/design_system/design_system.dart';
import 'package:taller_mecanico_frontend/core/layout/puntos_corte.dart';
import 'package:taller_mecanico_frontend/core/routing/router.dart';
import 'package:taller_mecanico_frontend/features/ajustes/datos/preferencias.dart';
import 'package:taller_mecanico_frontend/features/clientes/presentacion/proveedores/clientes_proveedores.dart';
import 'package:taller_mecanico_frontend/features/servicios/presentacion/proveedores/servicios_proveedores.dart';
import 'package:taller_mecanico_frontend/features/vehiculos/presentacion/proveedores/vehiculos_proveedores.dart';

import '../../ayudas/dobles.dart';

Future<void> _navegarA(
  WidgetTester tester,
  String ruta, {
  required double ancho,
  List<Override> overrides = const [],
}) async {
  tester.view.physicalSize = Size(ancho, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  SharedPreferences.setMockInitialValues({});
  final preferencias = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      repositorioClientesProvider.overrideWithValue(RepositorioClientesFalso()),
      repositorioVehiculosProvider.overrideWithValue(RepositorioVehiculosFalso()),
      repositorioServiciosProvider.overrideWithValue(RepositorioServiciosFalso()),
      preferenciasProvider.overrideWithValue(preferencias),
      ...overrides,
    ],
  );
  addTearDown(container.dispose);

  final router = container.read(routerProvider);
  router.go(ruta);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        theme: temaPrecision(const PaletaPrecisionClara(), Brightness.light),
        routerConfig: router,
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
}

void main() {
  group('PuntoCorte.desdeAncho', () {
    test('639 es compacto, 640 ya es medio', () {
      expect(PuntoCorte.desdeAncho(639), PuntoCorte.compacto);
      expect(PuntoCorte.desdeAncho(640), PuntoCorte.medio);
    });

    test('1023 es medio, 1024 ya es expandido', () {
      expect(PuntoCorte.desdeAncho(1023), PuntoCorte.medio);
      expect(PuntoCorte.desdeAncho(1024), PuntoCorte.expandido);
    });
  });

  group('AndamioAdaptativo cambia de NavigationBar a NavigationRail', () {
    testWidgets('compacto (375) muestra NavigationBar, no NavigationRail', (tester) async {
      await _navegarA(tester, '/clientes', ancho: 375);

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
    });

    testWidgets('medio (800) muestra NavigationRail sin extender, no NavigationBar', (
      tester,
    ) async {
      await _navegarA(tester, '/clientes', ancho: 800);

      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
      final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
      expect(rail.extended, isFalse);
    });

    testWidgets('expandido (1280) muestra NavigationRail extendido', (tester) async {
      await _navegarA(tester, '/clientes', ancho: 1280);

      expect(find.byType(NavigationRail), findsOneWidget);
      final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
      expect(rail.extended, isTrue);
    });

    testWidgets('el destino de la ruta activa queda seleccionado', (tester) async {
      await _navegarA(tester, '/ajustes', ancho: 1280);

      final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
      expect(rail.selectedIndex, 1);
    });
  });

  group('sin overflow en ningun ancho', () {
    for (final ancho in [360.0, 640.0, 800.0, 1024.0, 1440.0]) {
      testWidgets('/clientes a $ancho de ancho no tira overflow', (tester) async {
        await _navegarA(tester, '/clientes', ancho: ancho);
        expect(tester.takeException(), isNull);
      });

      testWidgets('/clientes/1/vehiculos a $ancho de ancho no tira overflow', (tester) async {
        await _navegarA(tester, '/clientes/1/vehiculos', ancho: ancho);
        expect(tester.takeException(), isNull);
      });

      testWidgets('/clientes/1/vehiculos/1/servicios a $ancho de ancho no tira overflow', (
        tester,
      ) async {
        await _navegarA(tester, '/clientes/1/vehiculos/1/servicios', ancho: ancho);
        expect(tester.takeException(), isNull);
      });

      testWidgets('/clientes/nuevo a $ancho de ancho no tira overflow', (tester) async {
        await _navegarA(tester, '/clientes/nuevo', ancho: ancho);
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('maestro-detalle', () {
    testWidgets('en /clientes ancho, sin seleccion se ve el estado vacio', (tester) async {
      await _navegarA(tester, '/clientes', ancho: 1280);

      expect(find.text('Seleccioná un cliente'), findsOneWidget);
    });

    testWidgets('en /clientes/1/vehiculos ancho, se ve la lista de vehiculos y el vacio de servicios', (
      tester,
    ) async {
      await _navegarA(tester, '/clientes/1/vehiculos', ancho: 1280);

      expect(find.text('Toyota Hilux (2020)'), findsOneWidget);
      expect(find.text('Seleccioná un vehículo'), findsOneWidget);
    });

    testWidgets('en /clientes/1/vehiculos/1/servicios ancho, la lista de vehiculos queda al lado del historial', (
      tester,
    ) async {
      await _navegarA(tester, '/clientes/1/vehiculos/1/servicios', ancho: 1280);

      // Aparece 2 veces a propósito: una vez en la fila del maestro (resaltada
      // como seleccionada) y otra vez como título del AppBar del detalle.
      expect(find.text('Toyota Hilux (2020)'), findsNWidgets(2));
      expect(find.text('2 servicios'), findsOneWidget);
    });
  });
}
