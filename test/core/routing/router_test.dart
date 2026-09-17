import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/misc.dart' show Override;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taller_mecanico_frontend/core/design_system/design_system.dart';
import 'package:taller_mecanico_frontend/core/routing/router.dart';
import 'package:taller_mecanico_frontend/features/ajustes/datos/preferencias.dart';
import 'package:taller_mecanico_frontend/features/clientes/presentacion/proveedores/clientes_proveedores.dart';
import 'package:taller_mecanico_frontend/features/servicios/presentacion/proveedores/servicios_proveedores.dart';
import 'package:taller_mecanico_frontend/features/vehiculos/presentacion/proveedores/vehiculos_proveedores.dart';

import '../../ayudas/dobles.dart';

Future<void> _navegarA(WidgetTester tester, String ruta, {List<Override> overrides = const []}) async {
  // Ancho compacto fijo: estos tests verifican que cada ruta resuelve a la
  // pantalla correcta, no el comportamiento adaptativo de F7 (eso lo cubre
  // adaptativo_test.dart). Con un ancho medio/expandido el rail de
  // AndamioAdaptativo duplicaría textos como "Clientes"/"Ajustes".
  tester.view.physicalSize = const Size(390, 844);
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
  group('cada ruta definida resuelve a la pantalla esperada', () {
    testWidgets('/clientes -> PantallaClientes', (tester) async {
      await _navegarA(tester, '/clientes');
      expect(find.widgetWithText(AppBar, 'Clientes'), findsOneWidget);
      expect(find.text('Ana Gomez'), findsOneWidget);
    });

    testWidgets('/clientes/nuevo -> FormularioCliente', (tester) async {
      await _navegarA(tester, '/clientes/nuevo');
      expect(find.text('Nuevo cliente'), findsOneWidget);
    });

    testWidgets('/clientes/1/editar -> FormularioCliente con el cliente 1', (tester) async {
      await _navegarA(tester, '/clientes/1/editar');
      expect(find.text('Editar cliente'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Nombre'), findsOneWidget);
    });

    testWidgets('/clientes/1/vehiculos -> PantallaVehiculos', (tester) async {
      await _navegarA(tester, '/clientes/1/vehiculos');
      expect(find.text('Toyota Hilux (2020)'), findsOneWidget);
      expect(find.text('Volkswagen Golf (2018)'), findsOneWidget);
    });

    testWidgets('/clientes/1/vehiculos/nuevo -> FormularioVehiculo', (tester) async {
      await _navegarA(tester, '/clientes/1/vehiculos/nuevo');
      expect(find.text('Nuevo vehículo'), findsOneWidget);
    });

    testWidgets('/clientes/1/vehiculos/1/editar -> FormularioVehiculo con el vehiculo 1', (
      tester,
    ) async {
      await _navegarA(tester, '/clientes/1/vehiculos/1/editar');
      expect(find.text('Editar vehículo'), findsOneWidget);
    });

    testWidgets('/clientes/1/vehiculos/1/servicios -> PantallaServicios', (tester) async {
      await _navegarA(tester, '/clientes/1/vehiculos/1/servicios');
      expect(find.text('2 servicios'), findsOneWidget);
    });

    testWidgets('/clientes/1/vehiculos/1/servicios/nuevo -> FormularioServicio', (tester) async {
      await _navegarA(tester, '/clientes/1/vehiculos/1/servicios/nuevo');
      expect(find.text('Nuevo servicio'), findsOneWidget);
    });

    testWidgets(
      '/clientes/1/vehiculos/1/servicios/1/editar -> FormularioServicio con el servicio 1',
      (tester) async {
        await _navegarA(tester, '/clientes/1/vehiculos/1/servicios/1/editar');
        expect(find.text('Editar servicio'), findsOneWidget);
      },
    );

    testWidgets('/ajustes -> PantallaAjustes', (tester) async {
      await _navegarA(tester, '/ajustes');
      expect(find.widgetWithText(AppBar, 'Ajustes'), findsOneWidget);
    });
  });

  group('deep link', () {
    testWidgets('entrar directo a servicios resuelve el vehiculo 2 desde el id, no el 1', (
      tester,
    ) async {
      await _navegarA(tester, '/clientes/1/vehiculos/2/servicios');

      expect(find.text('Volkswagen Golf (2018)'), findsOneWidget);
      expect(find.text('Toyota Hilux (2020)'), findsNothing);
    });

    testWidgets('un id inexistente muestra el error de VistaAsync, no una excepcion sin manejar', (
      tester,
    ) async {
      await _navegarA(tester, '/clientes/9999/vehiculos');

      expect(find.text('Reintentar'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('un id no numerico muestra la pantalla de no encontrado, no lanza', (
      tester,
    ) async {
      await _navegarA(tester, '/clientes/abc/vehiculos');

      expect(find.text('No encontramos esta página'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('una ruta que no existe cae en errorBuilder', (tester) async {
    await _navegarA(tester, '/esto/no/existe');
    expect(find.text('No encontramos esta página'), findsOneWidget);
  });
}
