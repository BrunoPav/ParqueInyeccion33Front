import 'dart:convert';

import 'package:http/http.dart' as http;

import '../modelos/servicio.dart';
import 'api_base.dart';

class ApiServicio {
  static const String _ruta = '/api/servicios';

  Future<List<Servicio>> listar({int? vehiculoId}) {
    return ejecutar(() async {
      final parametros = <String, String>{};
      if (vehiculoId != null) {
        parametros['vehiculoId'] = vehiculoId.toString();
      }

      final respuesta = await http.get(construirUri(_ruta, parametros));
      final lista = decodificar(respuesta) as List<dynamic>;
      return lista
          .map((json) => Servicio.desdeJson(json as Map<String, dynamic>))
          .toList();
    });
  }

  Future<Servicio> obtener(int id) {
    return ejecutar(() async {
      final respuesta = await http.get(construirUri('$_ruta/$id'));
      return Servicio.desdeJson(decodificar(respuesta) as Map<String, dynamic>);
    });
  }

  Future<Servicio> crear(Servicio servicio) {
    return ejecutar(() async {
      final respuesta = await http.post(
        construirUri(_ruta),
        headers: cabecerasJson,
        body: jsonEncode(servicio.aJson()),
      );
      return Servicio.desdeJson(decodificar(respuesta) as Map<String, dynamic>);
    });
  }

  Future<Servicio> reemplazar(int id, Servicio servicio) {
    return ejecutar(() async {
      final respuesta = await http.put(
        construirUri('$_ruta/$id'),
        headers: cabecerasJson,
        body: jsonEncode(servicio.aJson()),
      );
      return Servicio.desdeJson(decodificar(respuesta) as Map<String, dynamic>);
    });
  }

  Future<void> eliminar(int id) {
    return ejecutar(() async {
      final respuesta = await http.delete(construirUri('$_ruta/$id'));
      decodificar(respuesta);
    });
  }
}
