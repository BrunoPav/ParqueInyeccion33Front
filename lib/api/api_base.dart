import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config.dart';
import 'excepciones.dart';

const Map<String, String> cabecerasJson = {
  'Content-Type': 'application/json; charset=utf-8',
};

Uri construirUri(String ruta, [Map<String, String>? parametros]) {
  final base = Uri.parse(urlBaseApi);
  return base.replace(
    path: ruta,
    queryParameters: (parametros == null || parametros.isEmpty) ? null : parametros,
  );
}

dynamic decodificar(http.Response respuesta) {
  final tieneCuerpo = respuesta.bodyBytes.isNotEmpty;
  final cuerpo = tieneCuerpo ? jsonDecode(utf8.decode(respuesta.bodyBytes)) : null;

  if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
    return cuerpo;
  }

  final mensaje = (cuerpo is Map<String, dynamic> && cuerpo['mensaje'] is String)
      ? cuerpo['mensaje'] as String
      : 'Error ${respuesta.statusCode}';

  throw ExcepcionApi(respuesta.statusCode, mensaje);
}

Future<T> ejecutar<T>(Future<T> Function() peticion) async {
  try {
    return await peticion();
  } on SocketException {
    throw const ExcepcionConexion('No se pudo conectar con el servidor');
  } on http.ClientException {
    throw const ExcepcionConexion('No se pudo conectar con el servidor');
  }
}
