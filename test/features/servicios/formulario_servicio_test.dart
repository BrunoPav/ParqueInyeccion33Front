import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taller_mecanico_frontend/core/routing/router.dart';
import 'package:taller_mecanico_frontend/features/servicios/dominio/repositorio_servicios.dart';
import 'package:taller_mecanico_frontend/features/servicios/dominio/servicio.dart';
import 'package:taller_mecanico_frontend/features/servicios/presentacion/proveedores/servicios_proveedores.dart';
import 'package:taller_mecanico_frontend/features/vehiculos/dominio/vehiculo.dart';

import '../../ayudas/bombear_pantalla.dart';

/// `crear` de verdad agrega a la lista en memoria, para probar que guardar
/// invalida la lista de la pantalla anterior de punta a punta (F9.31) — el
/// doble compartido (`RepositorioServiciosFalso`) lanza `UnimplementedError`.
class _RepositorioServiciosEnMemoria implements RepositorioServicios {
  final List<Servicio> _servicios = [];
  int _siguienteId = 1;

  @override
  Future<List<Servicio>> listar({int? vehiculoId}) async => List.unmodifiable(_servicios);

  @override
  Future<Servicio> obtener(int id) async => _servicios.firstWhere((s) => s.id == id);

  @override
  Future<Servicio> crear(Servicio servicio) async {
    final conId = Servicio(
      id: _siguienteId++,
      fecha: servicio.fecha,
      descripcion: servicio.descripcion,
      precio: servicio.precio,
      vehiculoId: servicio.vehiculoId,
    );
    _servicios.add(conId);
    return conId;
  }

  @override
  Future<Servicio> reemplazar(int id, Servicio servicio) async => throw UnimplementedError();

  @override
  Future<void> eliminar(int id) async => throw UnimplementedError();
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

  testWidgets('guardar un servicio nuevo invalida la lista y vuelve', (tester) async {
    final router = ProviderContainer().read(routerProvider);
    await bombearPantalla(
      tester,
      null,
      enrutador: router,
      overrides: [
        repositorioServiciosProvider.overrideWithValue(_RepositorioServiciosEnMemoria()),
      ],
    );
    router.go('/clientes/1/vehiculos/1/servicios', extra: vehiculo);
    await tester.pump();
    await tester.pump();

    expect(find.text('Este vehículo no tiene servicios registrados'), findsOneWidget);

    await tester.tap(find.text('Nuevo servicio'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Descripción'),
      'Cambio de aceite',
    );
    await tester.enterText(find.widgetWithText(TextFormField, 'Precio'), '45000');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Toyota Hilux (2020)'), findsOneWidget);
    expect(find.text('Cambio de aceite'), findsOneWidget);
  });

  testWidgets('salir de un formulario con cambios sin guardar pide confirmacion', (tester) async {
    final router = ProviderContainer().read(routerProvider);
    await bombearPantalla(
      tester,
      null,
      enrutador: router,
      overrides: [
        repositorioServiciosProvider.overrideWithValue(_RepositorioServiciosEnMemoria()),
      ],
    );
    router.go('/clientes/1/vehiculos/1/servicios', extra: vehiculo);
    await tester.pump();
    await tester.pump();
    await tester.tap(find.text('Nuevo servicio'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Descripción'),
      'Algo sin guardar',
    );
    await tester.pump();

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.text('Descartar cambios'), findsOneWidget);

    await tester.tap(find.text('Descartar'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Toyota Hilux (2020)'), findsOneWidget);
  });
}
