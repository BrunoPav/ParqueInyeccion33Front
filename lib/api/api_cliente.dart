import 'dart:convert';

import 'package:http/http.dart' as http;

import '../modelos/cliente.dart';
import 'api_base.dart';

class ApiCliente {
  static const String _ruta = '/api/clientes';

  Future<List<Cliente>> listar({String? nombre, bool activo = true}) {
    return ejecutar(() async {
      final parametros = <String, String>{'activo': activo.toString()};
      if (nombre != null && nombre.isNotEmpty) {
        parametros['nombre'] = nombre;
      }

      final respuesta = await http.get(construirUri(_ruta, parametros));
      final lista = decodificar(respuesta) as List<dynamic>;
      return lista
          .map((json) => Cliente.desdeJson(json as Map<String, dynamic>))
          .toList();
    });
  }

  Future<Cliente> obtener(int id) {
    return ejecutar(() async {
      final respuesta = await http.get(construirUri('$_ruta/$id'));
      return Cliente.desdeJson(decodificar(respuesta) as Map<String, dynamic>);
    });
  }

  Future<Cliente> crear(Cliente cliente) {
    return ejecutar(() async {
      final respuesta = await http.post(
        construirUri(_ruta),
        headers: cabecerasJson,
        body: jsonEncode(cliente.aJson()),
      );
      return Cliente.desdeJson(decodificar(respuesta) as Map<String, dynamic>);
    });
  }

  Future<Cliente> reemplazar(int id, Cliente cliente) {
    return ejecutar(() async {
      final respuesta = await http.put(
        construirUri('$_ruta/$id'),
        headers: cabecerasJson,
        body: jsonEncode(cliente.aJson()),
      );
      return Cliente.desdeJson(decodificar(respuesta) as Map<String, dynamic>);
    });
  }

  Future<Cliente> cambiarEstado(int id, bool activo) {
    return ejecutar(() async {
      final respuesta = await http.patch(
        construirUri('$_ruta/$id'),
        headers: cabecerasJson,
        body: jsonEncode({'activo': activo}),
      );
      return Cliente.desdeJson(decodificar(respuesta) as Map<String, dynamic>);
    });
  }
}
