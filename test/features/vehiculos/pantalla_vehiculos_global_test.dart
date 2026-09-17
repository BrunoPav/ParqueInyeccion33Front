import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taller_mecanico_frontend/features/vehiculos/dominio/repositorio_vehiculos.dart';
import 'package:taller_mecanico_frontend/features/vehiculos/dominio/vehiculo.dart';
import 'package:taller_mecanico_frontend/features/vehiculos/presentacion/pantallas/pantalla_vehiculos_global.dart';
import 'package:taller_mecanico_frontend/features/vehiculos/presentacion/proveedores/vehiculos_proveedores.dart';

import '../../ayudas/bombear_pantalla.dart';
import '../../ayudas/dobles.dart';

class _RepositorioVehiculosBuscable implements RepositorioVehiculos {
  @override
  Future<List<Vehiculo>> listar({int? clienteId}) async {
    return const [
      Vehiculo(
        id: 1,
        marca: 'Toyota',
        modelo: 'Hilux',
        anio: 2020,
        patente: 'AF320OK',
        kilometraje: 124500,
        clienteId: 1,
      ),
      Vehiculo(
        id: 2,
        marca: 'Volkswagen',
        modelo: 'Golf',
        anio: 2018,
        patente: 'AC712MN',
        kilometraje: 88200,
        clienteId: 2,
      ),
    ];
  }

  @override
  Future<Vehiculo> obtener(int id) async => throw UnimplementedError();

  @override
  Future<Vehiculo> porPatente(String patente) async {
    final lista = await listar();
    return lista.firstWhere(
      (v) => v.patente == patente,
      orElse: () => throw Exception('no encontrado'),
    );
  }

  @override
  Future<Vehiculo> crear(Vehiculo vehiculo) async => throw UnimplementedError();

  @override
  Future<Vehiculo> reemplazar(int id, Vehiculo vehiculo) async => throw UnimplementedError();

  @override
  Future<void> eliminar(int id) async => throw UnimplementedError();
}

void main() {
  testWidgets('muestra todos los vehiculos sin filtrar por cliente', (tester) async {
    await bombearPantalla(
      tester,
      const PantallaVehiculosGlobal(),
      overrides: [repositorioVehiculosProvider.overrideWithValue(_RepositorioVehiculosBuscable())],
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Toyota Hilux (2020)'), findsOneWidget);
    expect(find.text('Volkswagen Golf (2018)'), findsOneWidget);
  });

  testWidgets('buscar por patente exacta muestra solo ese vehiculo', (tester) async {
    await bombearPantalla(
      tester,
      const PantallaVehiculosGlobal(),
      overrides: [repositorioVehiculosProvider.overrideWithValue(_RepositorioVehiculosBuscable())],
    );
    await tester.pump();
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'AC712MN');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();

    expect(find.text('Volkswagen Golf (2018)'), findsOneWidget);
    expect(find.text('Toyota Hilux (2020)'), findsNothing);
  });

  testWidgets('buscar una patente inexistente muestra el estado vacio de busqueda', (
    tester,
  ) async {
    await bombearPantalla(
      tester,
      const PantallaVehiculosGlobal(),
      overrides: [repositorioVehiculosProvider.overrideWithValue(RepositorioVehiculosFalso())],
    );
    await tester.pump();
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'ZZ999ZZ');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();

    expect(find.text('No se encontró ningún vehículo con esa patente'), findsOneWidget);
  });
}
