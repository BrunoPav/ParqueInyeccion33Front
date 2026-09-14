import 'package:flutter_test/flutter_test.dart';
import 'package:taller_mecanico_frontend/features/clientes/presentacion/pantallas/pantalla_clientes.dart';
import 'package:taller_mecanico_frontend/features/clientes/presentacion/proveedores/clientes_proveedores.dart';

import '../../ayudas/bombear_pantalla.dart';
import '../../ayudas/dobles.dart';

void main() {
  testWidgets('la pantalla de clientes muestra lo que devuelve la API', (
    tester,
  ) async {
    await bombearPantalla(
      tester,
      const PantallaClientes(),
      overrides: [repositorioClientesProvider.overrideWithValue(RepositorioClientesFalso())],
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
      overrides: [repositorioClientesProvider.overrideWithValue(RepositorioClientesVacio())],
    );

    await tester.pump();
    await tester.pump();

    expect(find.text('No hay clientes activos'), findsOneWidget);
  });
}
