import 'package:taller_mecanico_frontend/api/api_cliente.dart';
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

class ApiClienteVacia extends ApiCliente {
  @override
  Future<List<Cliente>> listar({String? nombre, bool activo = true}) async {
    return [];
  }
}
