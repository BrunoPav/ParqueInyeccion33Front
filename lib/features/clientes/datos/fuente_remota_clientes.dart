import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/red/cliente_http.dart';
import 'cliente_dto.dart';

class FuenteRemotaClientes {
  static const String _ruta = '/api/clientes';

  Future<List<ClienteDto>> listar({String? nombre, bool activo = true}) {
    return ejecutar(() async {
      final parametros = <String, String>{'activo': activo.toString()};
      if (nombre != null && nombre.isNotEmpty) {
        parametros['nombre'] = nombre;
      }

      final respuesta = await http.get(construirUri(_ruta, parametros));
      final lista = decodificar(respuesta) as List<dynamic>;
      return lista
          .map((json) => ClienteDto.desdeJson(json as Map<String, dynamic>))
          .toList();
    });
  }

  Future<ClienteDto> obtener(int id) {
    return ejecutar(() async {
      final respuesta = await http.get(construirUri('$_ruta/$id'));
      return ClienteDto.desdeJson(decodificar(respuesta) as Map<String, dynamic>);
    });
  }

  Future<ClienteDto> crear(ClienteDto cliente) {
    return ejecutar(() async {
      final respuesta = await http.post(
        construirUri(_ruta),
        headers: cabecerasJson,
        body: jsonEncode(cliente.aJson()),
      );
      return ClienteDto.desdeJson(decodificar(respuesta) as Map<String, dynamic>);
    });
  }

  Future<ClienteDto> reemplazar(int id, ClienteDto cliente) {
    return ejecutar(() async {
      final respuesta = await http.put(
        construirUri('$_ruta/$id'),
        headers: cabecerasJson,
        body: jsonEncode(cliente.aJson()),
      );
      return ClienteDto.desdeJson(decodificar(respuesta) as Map<String, dynamic>);
    });
  }

  Future<ClienteDto> cambiarEstado(int id, bool activo) {
    return ejecutar(() async {
      final respuesta = await http.patch(
        construirUri('$_ruta/$id'),
        headers: cabecerasJson,
        body: jsonEncode({'activo': activo}),
      );
      return ClienteDto.desdeJson(decodificar(respuesta) as Map<String, dynamic>);
    });
  }
}
