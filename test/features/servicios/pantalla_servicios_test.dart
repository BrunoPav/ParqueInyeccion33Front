import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taller_mecanico_frontend/features/servicios/dominio/repositorio_servicios.dart';
import 'package:taller_mecanico_frontend/features/servicios/dominio/servicio.dart';
import 'package:taller_mecanico_frontend/features/servicios/presentacion/pantallas/pantalla_servicios.dart';
import 'package:taller_mecanico_frontend/features/servicios/presentacion/proveedores/servicios_proveedores.dart';
import 'package:taller_mecanico_frontend/features/vehiculos/dominio/vehiculo.dart';

import '../../ayudas/bombear_pantalla.dart';
import '../../ayudas/dobles.dart';

/// `eliminar` de verdad saca el servicio de la lista en memoria, para
/// probar el camino completo de `dialogoConfirmacion` (F9.35) — el doble
/// compartido lanza `UnimplementedError`.
class _RepositorioServiciosEliminable implements RepositorioServicios {
  final List<Servicio> _servicios = [
    Servicio(id: 1, fecha: DateTime(2025, 2, 12), descripcion: 'Cambio de aceite', precio: 50000, vehiculoId: 1),
  ];

  @override
  Future<List<Servicio>> listar({int? vehiculoId}) async => List.unmodifiable(_servicios);

  @override
  Future<Servicio> obtener(int id) async => _servicios.firstWhere((s) => s.id == id);

  @override
  Future<Servicio> crear(Servicio servicio) async => throw UnimplementedError();

  @override
  Future<Servicio> reemplazar(int id, Servicio servicio) async => throw UnimplementedError();

  @override
  Future<void> eliminar(int id) async {
    _servicios.removeWhere((s) => s.id == id);
  }
}

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
      const PantallaServicios(clienteId: 1, vehiculoId: 1, vehiculoExtra: vehiculo),
      overrides: [repositorioServiciosProvider.overrideWithValue(RepositorioServiciosFalso())],
    );

    await tester.pump();
    await tester.pump();

    expect(find.text('2 servicios'), findsOneWidget);
    expect(find.text('\$ 240500.00'), findsOneWidget);
  });

  testWidgets('muestra un mensaje cuando el vehiculo no tiene servicios', (tester) async {
    await bombearPantalla(
      tester,
      const PantallaServicios(clienteId: 1, vehiculoId: 1, vehiculoExtra: vehiculo),
      overrides: [repositorioServiciosProvider.overrideWithValue(RepositorioServiciosVacio())],
    );

    await tester.pump();
    await tester.pump();

    expect(find.text('Este vehículo no tiene servicios registrados'), findsOneWidget);
  });

  testWidgets('eliminar servicio: cancelar no borra, confirmar borra y refresca', (tester) async {
    final repositorio = _RepositorioServiciosEliminable();
    await bombearPantalla(
      tester,
      const PantallaServicios(clienteId: 1, vehiculoId: 1, vehiculoExtra: vehiculo),
      overrides: [repositorioServiciosProvider.overrideWithValue(repositorio)],
    );
    await tester.pump();
    await tester.pump();
    expect(find.text('Cambio de aceite'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(find.text('Cambio de aceite'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eliminar').last);
    await tester.pumpAndSettle();

    expect(find.text('Cambio de aceite'), findsNothing);
  });
}
