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
