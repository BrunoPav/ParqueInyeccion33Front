import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/red/cliente_http.dart';
import 'sesion_dto.dart';

class FuenteRemotaSesion {
  static const String _ruta = '/api/auth/login';

  Future<SesionDto> iniciarSesion(String nombreUsuario, String contrasena) {
    return ejecutar(() async {
      final respuesta = await http.post(
        construirUri(_ruta),
        headers: cabecerasJson,
        body: jsonEncode({
          'nombreUsuario': nombreUsuario,
          'contrasena': contrasena,
        }),
      );
      return SesionDto.desdeJson(decodificar(respuesta) as Map<String, dynamic>);
    });
  }
}
