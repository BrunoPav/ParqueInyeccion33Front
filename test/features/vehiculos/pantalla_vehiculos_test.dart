import 'package:flutter_test/flutter_test.dart';
import 'package:taller_mecanico_frontend/features/clientes/dominio/cliente.dart';
import 'package:taller_mecanico_frontend/features/vehiculos/presentacion/pantallas/pantalla_vehiculos.dart';
import 'package:taller_mecanico_frontend/features/vehiculos/presentacion/proveedores/vehiculos_proveedores.dart';

import '../../ayudas/bombear_pantalla.dart';
import '../../ayudas/dobles.dart';

void main() {
  const cliente = Cliente(id: 1, nombre: 'Ana Gomez');

  testWidgets('la pantalla de vehiculos muestra lo que devuelve el repositorio', (
    tester,
  ) async {
    await bombearPantalla(
      tester,
      const PantallaVehiculos(cliente: cliente),
      overrides: [repositorioVehiculosProvider.overrideWithValue(RepositorioVehiculosFalso())],
    );

    await tester.pump();
    await tester.pump();

    expect(find.text('Toyota Hilux (2020)'), findsOneWidget);
    expect(find.text('Volkswagen Golf (2018)'), findsOneWidget);
  });

  testWidgets('muestra un mensaje cuando el cliente no tiene vehiculos', (tester) async {
    await bombearPantalla(
      tester,
      const PantallaVehiculos(cliente: cliente),
      overrides: [repositorioVehiculosProvider.overrideWithValue(RepositorioVehiculosVacio())],
    );

    await tester.pump();
    await tester.pump();

    expect(find.text('Este cliente no tiene vehiculos'), findsOneWidget);
  });
}
