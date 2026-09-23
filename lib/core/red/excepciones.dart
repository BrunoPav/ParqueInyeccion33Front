class ExcepcionApi implements Exception {
  final int status;
  final String mensaje;

  const ExcepcionApi(this.status, this.mensaje);

  @override
  String toString() => mensaje;
}

class ExcepcionConexion implements Exception {
  final String mensaje;

  const ExcepcionConexion(this.mensaje);

  @override
  String toString() => mensaje;
}

/// `true` cuando el error es la API pidiendo credenciales.
bool requiereSesion(Object error) =>
    error is ExcepcionApi && (error.status == 401 || error.status == 403);

/// Traduce un error de red a algo accionable para quien lo lee.
///
/// El 401 y el 403 son el caso interesante: no son fallas, son la API pidiendo
/// credenciales. Mostrar "Error 403" ahi dejaria al usuario sin saber que hacer.
String mensajeDeError(Object error) {
  if (error is ExcepcionApi) {
    return switch (error.status) {
      401 || 403 => 'Iniciá sesión para crear o editar registros',
      _ => error.mensaje,
    };
  }
  return error.toString();
}
