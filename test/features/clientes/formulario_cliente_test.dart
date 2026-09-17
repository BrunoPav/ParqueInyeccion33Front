import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taller_mecanico_frontend/core/routing/router.dart';
import 'package:taller_mecanico_frontend/features/clientes/dominio/cliente.dart';
import 'package:taller_mecanico_frontend/features/clientes/dominio/repositorio_clientes.dart';
import 'package:taller_mecanico_frontend/features/clientes/presentacion/proveedores/clientes_proveedores.dart';

import '../../ayudas/bombear_pantalla.dart';

/// `crear` de verdad agrega a la lista en memoria, para probar que guardar
/// invalida la lista de la pantalla anterior de punta a punta (F9.31) — el
/// doble compartido (`RepositorioClientesFalso`) lanza `UnimplementedError`.
class _RepositorioClientesEnMemoria implements RepositorioClientes {
  final List<Cliente> _clientes = [];
  int _siguienteId = 1;

  @override
  Future<List<Cliente>> listar({String? nombre, bool activo = true}) async =>
      List.unmodifiable(_clientes);

  @override
  Future<Cliente> obtener(int id) async => _clientes.firstWhere((c) => c.id == id);

  @override
  Future<Cliente> crear(Cliente cliente) async {
    final conId = Cliente(
      id: _siguienteId++,
      nombre: cliente.nombre,
      contacto: cliente.contacto,
      activo: cliente.activo,
    );
    _clientes.add(conId);
    return conId;
  }

  @override
  Future<Cliente> reemplazar(int id, Cliente cliente) async => throw UnimplementedError();

  @override
  Future<Cliente> cambiarEstado(int id, bool activo) async => throw UnimplementedError();
}

void main() {
  testWidgets('guardar un cliente nuevo invalida la lista y vuelve', (tester) async {
    final router = ProviderContainer().read(routerProvider);
    await bombearPantalla(
      tester,
      null,
      enrutador: router,
      overrides: [
        repositorioClientesProvider.overrideWithValue(_RepositorioClientesEnMemoria()),
      ],
    );
    router.go('/clientes');
    await tester.pump();
    await tester.pump();

    expect(find.text('No hay clientes activos'), findsOneWidget);

    await tester.tap(find.text('Nuevo cliente'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Nombre'), 'Cliente Nuevo');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    // Volvió a la lista de clientes sin refrescar a mano, y el nuevo
    // cliente ya aparece.
    expect(find.widgetWithText(AppBar, 'Clientes'), findsOneWidget);
    expect(find.text('Cliente Nuevo'), findsOneWidget);
  });

  testWidgets('salir de un formulario con cambios sin guardar pide confirmacion', (tester) async {
    final router = ProviderContainer().read(routerProvider);
    await bombearPantalla(
      tester,
      null,
      enrutador: router,
      overrides: [
        repositorioClientesProvider.overrideWithValue(_RepositorioClientesEnMemoria()),
      ],
    );
    router.go('/clientes');
    await tester.pump();
    await tester.pump();
    await tester.tap(find.text('Nuevo cliente'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Nombre'), 'Algo');
    await tester.pump();

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    // Sigue en el formulario: pide confirmar antes de descartar.
    expect(find.text('Descartar cambios'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Nombre'), findsOneWidget);

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextFormField, 'Nombre'), findsOneWidget);
    expect(find.text('Algo'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Descartar'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Clientes'), findsOneWidget);
  });
}
