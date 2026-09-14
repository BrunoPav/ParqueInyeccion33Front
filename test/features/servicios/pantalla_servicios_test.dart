import 'package:flutter_test/flutter_test.dart';
import 'package:taller_mecanico_frontend/features/servicios/dominio/servicio.dart';
import 'package:taller_mecanico_frontend/features/servicios/presentacion/pantallas/pantalla_servicios.dart';
import 'package:taller_mecanico_frontend/features/servicios/presentacion/proveedores/servicios_proveedores.dart';
import 'package:taller_mecanico_frontend/features/vehiculos/dominio/vehiculo.dart';

import '../../ayudas/bombear_pantalla.dart';
import '../../ayudas/dobles.dart';

void main() {
  const vehiculo = Vehiculo(
    id: 1,
    marca: 'Toyota',
    modelo: 'Hilux',
    anio: 2020,
    patente: 'AF320OK',
    kilometraje: 124500,
    clienteId: 1,
  );

  test('calcularTotal suma el precio de todos los servicios', () {
    final servicios = [
      Servicio(fecha: DateTime(2025, 2, 12), descripcion: 'a', precio: 148500, vehiculoId: 1),
      Servicio(fecha: DateTime(2024, 8, 18), descripcion: 'b', precio: 92000, vehiculoId: 1),
    ];

    expect(calcularTotal(servicios), 240500);
  });

  test('calcularTotal de una lista vacia es cero', () {
    expect(calcularTotal(const []), 0);
  });

  testWidgets('la pantalla de servicios muestra el listado y el total acumulado', (
    tester,
  ) async {
    await bombearPantalla(
      tester,
      const PantallaServicios(vehiculo: vehiculo),
      overrides: [repositorioServiciosProvider.overrideWithValue(RepositorioServiciosFalso())],
    );

    await tester.pump();
    await tester.pump();

    expect(find.text('2 servicios'), findsOneWidget);
    expect(find.text('Total: \$ 240500.00'), findsOneWidget);
  });

  testWidgets('muestra un mensaje cuando el vehiculo no tiene servicios', (tester) async {
    await bombearPantalla(
      tester,
      const PantallaServicios(vehiculo: vehiculo),
      overrides: [repositorioServiciosProvider.overrideWithValue(RepositorioServiciosVacio())],
    );

    await tester.pump();
    await tester.pump();

    expect(find.text('Este vehiculo no tiene servicios registrados'), findsOneWidget);
  });
}
