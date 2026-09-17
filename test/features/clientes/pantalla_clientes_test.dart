import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taller_mecanico_frontend/core/red/excepciones.dart';
import 'package:taller_mecanico_frontend/core/routing/router.dart';
import 'package:taller_mecanico_frontend/features/clientes/dominio/cliente.dart';
import 'package:taller_mecanico_frontend/features/clientes/dominio/repositorio_clientes.dart';
import 'package:taller_mecanico_frontend/features/clientes/presentacion/pantallas/pantalla_clientes.dart';
import 'package:taller_mecanico_frontend/features/clientes/presentacion/proveedores/clientes_proveedores.dart';

import '../../ayudas/bombear_pantalla.dart';
import '../../ayudas/dobles.dart';

/// Filtra de verdad por `nombre`, para probar el debounce de BarraBusqueda
/// (F9.32) — el doble compartido ignora ese parámetro.
class _RepositorioClientesFiltrable implements RepositorioClientes {
  @override
  Future<List<Cliente>> listar({String? nombre, bool activo = true}) async {
    const lista = [
      Cliente(id: 1, nombre: 'Ana Gomez'),
      Cliente(id: 2, nombre: 'Luis Diaz'),
    ];
    if (nombre == null || nombre.isEmpty) return lista;
    return lista.where((c) => c.nombre.toLowerCase().contains(nombre.toLowerCase())).toList();
  }

  @override
  Future<Cliente> obtener(int id) async => throw UnimplementedError();

  @override
  Future<Cliente> crear(Cliente cliente) async => throw UnimplementedError();

  @override
  Future<Cliente> reemplazar(int id, Cliente cliente) async => throw UnimplementedError();

  @override
  Future<Cliente> cambiarEstado(int id, bool activo) async => throw UnimplementedError();
}

/// Devuelve una lista distinta según `activo`, para probar que el chip
/// realmente dispara un pedido distinto (F9.33) — el doble compartido
/// siempre devuelve la misma lista fija.
class _RepositorioClientesPorEstado implements RepositorioClientes {
  @override
  Future<List<Cliente>> listar({String? nombre, bool activo = true}) async {
    return activo
        ? const [Cliente(id: 1, nombre: 'Cliente Activo')]
        : const [Cliente(id: 2, nombre: 'Cliente Inactivo', activo: false)];
  }

  @override
  Future<Cliente> obtener(int id) async => throw UnimplementedError();

  @override
  Future<Cliente> crear(Cliente cliente) async => throw UnimplementedError();

  @override
  Future<Cliente> reemplazar(int id, Cliente cliente) async => throw UnimplementedError();

  @override
  Future<Cliente> cambiarEstado(int id, bool activo) async => throw UnimplementedError();
}

/// Falla la primera vez y responde bien la segunda, para probar el camino
/// de error + reintentar de VistaAsync (F9.34).
class _RepositorioClientesFallaUnaVez implements RepositorioClientes {
  int _intentos = 0;

  @override
  Future<List<Cliente>> listar({String? nombre, bool activo = true}) async {
    _intentos++;
    // El delay es a propósito: sin él, un `async` sin ningún `await` real se
    // resuelve en el mismo tick del primer `pump()`, y el estado de carga
    // nunca llega a observarse.
    await Future<void>.delayed(const Duration(milliseconds: 10));
    if (_intentos == 1) throw Exception('sin conexion');
    return const [Cliente(id: 1, nombre: 'Ana Gomez')];
  }

  @override
  Future<Cliente> obtener(int id) async => throw UnimplementedError();

  @override
  Future<Cliente> crear(Cliente cliente) async => throw UnimplementedError();

  @override
  Future<Cliente> reemplazar(int id, Cliente cliente) async => throw UnimplementedError();

  @override
  Future<Cliente> cambiarEstado(int id, bool activo) async => throw UnimplementedError();
}

/// Siempre falla, con la excepción real de red/API del proyecto — para
/// confirmar que su mensaje llega entero a `VistaError` (F10.8, F10.9).
class _RepositorioClientesError implements RepositorioClientes {
  final Object error;

  _RepositorioClientesError(this.error);

  @override
  Future<List<Cliente>> listar({String? nombre, bool activo = true}) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    throw error;
  }

  @override
  Future<Cliente> obtener(int id) async => throw UnimplementedError();

  @override
  Future<Cliente> crear(Cliente cliente) async => throw UnimplementedError();

  @override
  Future<Cliente> reemplazar(int id, Cliente cliente) async => throw UnimplementedError();

  @override
  Future<Cliente> cambiarEstado(int id, bool activo) async => throw UnimplementedError();
}

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

  testWidgets('tocar una tarjeta de cliente navega a sus vehiculos', (tester) async {
    final router = ProviderContainer().read(routerProvider);
    await bombearPantalla(
      tester,
      null,
      enrutador: router,
      overrides: [repositorioClientesProvider.overrideWithValue(RepositorioClientesFalso())],
    );
    router.go('/clientes');
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('Ana Gomez'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Ana Gomez'), findsOneWidget);
  });

  testWidgets('BarraBusqueda no filtra antes del debounce, filtra despues', (tester) async {
    await bombearPantalla(
      tester,
      const PantallaClientes(),
      overrides: [repositorioClientesProvider.overrideWithValue(_RepositorioClientesFiltrable())],
    );
    await tester.pump();
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'Luis');
    await tester.pump(const Duration(milliseconds: 100));

    // Todavia no paso el debounce (400ms por defecto): sigue pidiendo con
    // el filtro anterior (vacio), la lista completa sigue mostrada.
    expect(find.text('Ana Gomez'), findsOneWidget);
    expect(find.text('Luis Diaz'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();
    await tester.pump();

    expect(find.text('Ana Gomez'), findsNothing);
    expect(find.text('Luis Diaz'), findsOneWidget);
  });

  testWidgets('alternar Activos/Inactivos pide y muestra una lista distinta', (tester) async {
    await bombearPantalla(
      tester,
      const PantallaClientes(),
      overrides: [
        repositorioClientesProvider.overrideWithValue(_RepositorioClientesPorEstado()),
      ],
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Cliente Activo'), findsOneWidget);
    expect(find.text('Cliente Inactivo'), findsNothing);

    await tester.tap(find.text('Inactivos'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Cliente Activo'), findsNothing);
    expect(find.text('Cliente Inactivo'), findsOneWidget);
  });

  testWidgets('VistaAsync: carga, luego error con Reintentar, luego datos', (tester) async {
    await bombearPantalla(
      tester,
      const PantallaClientes(),
      overrides: [
        repositorioClientesProvider.overrideWithValue(_RepositorioClientesFallaUnaVez()),
      ],
    );

    // Todavia no resuelve el Future: se ve el esqueleto de carga, no la
    // lista ni el error.
    await tester.pump();
    expect(find.text('Ana Gomez'), findsNothing);
    expect(find.text('Reintentar'), findsNothing);

    await tester.pump(const Duration(milliseconds: 20));
    expect(find.text('Reintentar'), findsOneWidget);

    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();

    expect(find.text('Reintentar'), findsNothing);
    expect(find.text('Ana Gomez'), findsOneWidget);
  });

  testWidgets('sin conexion: el mensaje de ExcepcionConexion llega entero a VistaError', (
    tester,
  ) async {
    await bombearPantalla(
      tester,
      const PantallaClientes(),
      overrides: [
        repositorioClientesProvider.overrideWithValue(
          _RepositorioClientesError(const ExcepcionConexion('No se pudo conectar con el servidor')),
        ),
      ],
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 20));

    expect(find.text('No se pudo conectar con el servidor'), findsOneWidget);
    expect(find.text('Reintentar'), findsOneWidget);
  });

  testWidgets('el mensaje de un error de API del backend llega entero a VistaError (F10.9)', (
    tester,
  ) async {
    await bombearPantalla(
      tester,
      const PantallaClientes(),
      overrides: [
        repositorioClientesProvider.overrideWithValue(
          _RepositorioClientesError(const ExcepcionApi(422, 'El nombre ya está en uso por otro cliente')),
        ),
      ],
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 20));

    expect(find.text('El nombre ya está en uso por otro cliente'), findsOneWidget);
  });
}
