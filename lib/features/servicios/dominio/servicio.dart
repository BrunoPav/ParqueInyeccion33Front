class Servicio {
  final int? id;
  final DateTime fecha;
  final String descripcion;
  final double precio;
  final int vehiculoId;

  const Servicio({
    this.id,
    required this.fecha,
    required this.descripcion,
    required this.precio,
    required this.vehiculoId,
  });
}

double calcularTotal(List<Servicio> servicios) {
  return servicios.fold(0, (suma, servicio) => suma + servicio.precio);
}
