import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taller_mecanico_frontend/api/api_cliente.dart';
import 'package:taller_mecanico_frontend/estado/proveedores.dart';
import 'package:taller_mecanico_frontend/main.dart';
import 'package:taller_mecanico_frontend/modelos/cliente.dart';

class ApiClienteFalso extends ApiCliente {
  @override
  Future<List<Cliente>> listar({String? nombre, bool activo = true}) async {
    return const [
      Cliente(id: 1, nombre: 'Ana Gomez', contacto: '11-1111-1111'),
      Cliente(id: 2, nombre: 'Luis Diaz'),
    ];
  }
}

void main() {
  testWidgets('la pantalla de clientes muestra lo que devuelve la API',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [apiClienteProvider.overrideWithValue(ApiClienteFalso())],
        child: const AplicacionTaller(),
      ),
    );

    await tester.pump();
    await tester.pump();

    expect(find.text('Ana Gomez'), findsOneWidget);
    expect(find.text('Luis Diaz'), findsOneWidget);
    expect(find.text('Sin contacto'), findsOneWidget);
  });

  testWidgets('muestra un mensaje cuando no hay clientes', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [apiClienteProvider.overrideWithValue(_ApiVacia())],
        child: const AplicacionTaller(),
      ),
    );

    await tester.pump();
    await tester.pump();

    expect(find.text('No hay clientes activos'), findsOneWidget);
  });
}

class _ApiVacia extends ApiCliente {
  @override
  Future<List<Cliente>> listar({String? nombre, bool activo = true}) async => [];
}
