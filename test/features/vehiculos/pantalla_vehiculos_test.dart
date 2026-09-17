import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taller_mecanico_frontend/core/routing/router.dart';
import 'package:taller_mecanico_frontend/features/clientes/dominio/cliente.dart';
import 'package:taller_mecanico_frontend/features/clientes/presentacion/proveedores/clientes_proveedores.dart';
import 'package:taller_mecanico_frontend/features/vehiculos/dominio/repositorio_vehiculos.dart';
import 'package:taller_mecanico_frontend/features/vehiculos/dominio/vehiculo.dart';
import 'package:taller_mecanico_frontend/features/vehiculos/presentacion/pantallas/pantalla_vehiculos.dart';
import 'package:taller_mecanico_frontend/features/vehiculos/presentacion/proveedores/vehiculos_proveedores.dart';

import '../../ayudas/bombear_pantalla.dart';
import '../../ayudas/dobles.dart';

/// `eliminar` de verdad saca el vehiculo de la lista en memoria, para
/// probar el camino completo de `dialogoConfirmacion` (F9.35) — el doble
/// compartido lanza `UnimplementedError`.
class _RepositorioVehiculosEliminable implements RepositorioVehiculos {
  final List<Vehiculo> _vehiculos = [
    const Vehiculo(
      id: 1,
      marca: 'Toyota',
      modelo: 'Hilux',
      anio: 2020,
      patente: 'AF320OK',
      kilometraje: 124500,
      clienteId: 1,
    ),
  ];

  @override
  Future<List<Vehiculo>> listar({int? clienteId}) async => List.unmodifiable(_vehiculos);

  @override
  Future<Vehiculo> obtener(int id) async => _vehiculos.firstWhere((v) => v.id == id);

  @override
  Future<Vehiculo> porPatente(String patente) async => throw UnimplementedError();

  @override
  Future<Vehiculo> crear(Vehiculo vehiculo) async => throw UnimplementedError();

  @override
  Future<Vehiculo> reemplazar(int id, Vehiculo vehiculo) async => throw UnimplementedError();

  @override
  Future<void> eliminar(int id) async {
    _vehiculos.removeWhere((v) => v.id == id);
  }
}

void main() {
  const cliente = Cliente(id: 1, nombre: 'Ana Gomez');

  testWidgets('la pantalla de vehiculos muestra lo que devuelve el repositorio', (
    tester,
  ) async {
    await bombearPantalla(
      tester,
      const PantallaVehiculos(clienteId: 1, clienteExtra: cliente),
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
      const PantallaVehiculos(clienteId: 1, clienteExtra: cliente),
      overrides: [repositorioVehiculosProvider.overrideWithValue(RepositorioVehiculosVacio())],
    );

    await tester.pump();
    await tester.pump();

    expect(find.text('Este cliente no tiene vehículos'), findsOneWidget);
  });

  testWidgets('tocar una tarjeta de vehiculo navega a sus servicios', (tester) async {
    final router = ProviderContainer().read(routerProvider);
    await bombearPantalla(
      tester,
      null,
      enrutador: router,
      overrides: [
        repositorioClientesProvider.overrideWithValue(RepositorioClientesFalso()),
        repositorioVehiculosProvider.overrideWithValue(RepositorioVehiculosFalso()),
      ],
    );
    router.go('/clientes/1/vehiculos', extra: cliente);
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('Toyota Hilux (2020)'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Toyota Hilux (2020)'), findsOneWidget);
  });

  testWidgets('eliminar vehiculo: cancelar no borra, confirmar borra y refresca', (tester) async {
    final repositorio = _RepositorioVehiculosEliminable();
    await bombearPantalla(
      tester,
      const PantallaVehiculos(clienteId: 1, clienteExtra: cliente),
      overrides: [repositorioVehiculosProvider.overrideWithValue(repositorio)],
    );
    await tester.pump();
    await tester.pump();
    expect(find.text('Toyota Hilux (2020)'), findsOneWidget);

    // Cancelar: el dialogo se cierra, el vehiculo sigue en la lista.
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(find.text('Toyota Hilux (2020)'), findsOneWidget);

    // Confirmar: se llama a eliminar() y la lista se refresca sin el.
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eliminar').last);
    await tester.pumpAndSettle();

    expect(find.text('Toyota Hilux (2020)'), findsNothing);
  });
}
