import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taller_mecanico_frontend/core/routing/router.dart';
import 'package:taller_mecanico_frontend/features/clientes/dominio/cliente.dart';
import 'package:taller_mecanico_frontend/features/vehiculos/dominio/repositorio_vehiculos.dart';
import 'package:taller_mecanico_frontend/features/vehiculos/dominio/vehiculo.dart';
import 'package:taller_mecanico_frontend/features/vehiculos/presentacion/proveedores/vehiculos_proveedores.dart';

import '../../ayudas/bombear_pantalla.dart';

/// `crear` de verdad agrega a la lista en memoria, para probar que guardar
/// invalida la lista de la pantalla anterior de punta a punta (F9.31) — el
/// doble compartido (`RepositorioVehiculosFalso`) lanza `UnimplementedError`.
class _RepositorioVehiculosEnMemoria implements RepositorioVehiculos {
  final List<Vehiculo> _vehiculos = [];
  int _siguienteId = 1;

  @override
  Future<List<Vehiculo>> listar({int? clienteId}) async => List.unmodifiable(_vehiculos);

  @override
  Future<Vehiculo> obtener(int id) async => _vehiculos.firstWhere((v) => v.id == id);

  @override
  Future<Vehiculo> porPatente(String patente) async => throw UnimplementedError();

  @override
  Future<Vehiculo> crear(Vehiculo vehiculo) async {
    final conId = Vehiculo(
      id: _siguienteId++,
      marca: vehiculo.marca,
      modelo: vehiculo.modelo,
      anio: vehiculo.anio,
      patente: vehiculo.patente,
      kilometraje: vehiculo.kilometraje,
      clienteId: vehiculo.clienteId,
    );
    _vehiculos.add(conId);
    return conId;
  }

  @override
  Future<Vehiculo> reemplazar(int id, Vehiculo vehiculo) async => throw UnimplementedError();

  @override
  Future<void> eliminar(int id) async => throw UnimplementedError();
}

void main() {
  const cliente = Cliente(id: 1, nombre: 'Ana Gomez');

  testWidgets('guardar un vehiculo nuevo invalida la lista y vuelve', (tester) async {
    final router = ProviderContainer().read(routerProvider);
    await bombearPantalla(
      tester,
      null,
      enrutador: router,
      overrides: [
        repositorioVehiculosProvider.overrideWithValue(_RepositorioVehiculosEnMemoria()),
      ],
    );
    router.go('/clientes/1/vehiculos', extra: cliente);
    await tester.pump();
    await tester.pump();

    expect(find.text('Este cliente no tiene vehículos'), findsOneWidget);

    await tester.tap(find.text('Nuevo vehículo'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Marca'), 'Ford');
    await tester.enterText(find.widgetWithText(TextFormField, 'Modelo'), 'Ranger');
    await tester.enterText(find.widgetWithText(TextFormField, 'Año'), '2022');
    await tester.enterText(find.widgetWithText(TextFormField, 'Patente'), 'AB123CD');
    await tester.enterText(find.widgetWithText(TextFormField, 'Kilometraje'), '5000');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Ana Gomez'), findsOneWidget);
    expect(find.text('Ford Ranger (2022)'), findsOneWidget);
  });

  testWidgets('salir de un formulario con cambios sin guardar pide confirmacion', (tester) async {
    final router = ProviderContainer().read(routerProvider);
    await bombearPantalla(
      tester,
      null,
      enrutador: router,
      overrides: [
        repositorioVehiculosProvider.overrideWithValue(_RepositorioVehiculosEnMemoria()),
      ],
    );
    router.go('/clientes/1/vehiculos', extra: cliente);
    await tester.pump();
    await tester.pump();
    await tester.tap(find.text('Nuevo vehículo'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Marca'), 'Ford');
    await tester.pump();

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.text('Descartar cambios'), findsOneWidget);

    await tester.tap(find.text('Descartar'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Ana Gomez'), findsOneWidget);
  });
}
