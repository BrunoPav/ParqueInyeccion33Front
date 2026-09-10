import 'package:flutter_test/flutter_test.dart';
import 'package:taller_mecanico_frontend/estado/proveedores.dart';
import 'package:taller_mecanico_frontend/pantallas/pantalla_clientes.dart';

import '../../ayudas/bombear_pantalla.dart';
import '../../ayudas/dobles.dart';

void main() {
  testWidgets('la pantalla de clientes muestra lo que devuelve la API', (
    tester,
  ) async {
    await bombearPantalla(
      tester,
      const PantallaClientes(),
      overrides: [apiClienteProvider.overrideWithValue(ApiClienteFalso())],
    );

    await tester.pump();
    await tester.pump();

    expect(find.text('Ana Gomez'), findsOneWidget);
    expect(find.text('Luis Diaz'), findsOneWidget);
    expect(find.text('Sin contacto'), findsOneWidget);
  });

  testWidgets('muestra un mensaje cuando no hay clientes', (tester) async {
    await bombearPantalla(
      tester,
      const PantallaClientes(),
      overrides: [apiClienteProvider.overrideWithValue(ApiClienteVacia())],
    );

    await tester.pump();
    await tester.pump();

    expect(find.text('No hay clientes activos'), findsOneWidget);
  });
}
