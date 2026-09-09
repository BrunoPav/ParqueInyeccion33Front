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

  factory Servicio.desdeJson(Map<String, dynamic> json) => Servicio(
        id: json['id'] as int?,
        fecha: DateTime.parse(json['fecha'] as String),
        descripcion: json['descripcion'] as String,
        precio: (json['precio'] as num).toDouble(),
        vehiculoId: json['vehiculoId'] as int,
      );

  Map<String, dynamic> aJson() => {
        'fecha': fecha.toIso8601String().split('T').first,
        'descripcion': descripcion,
        'precio': precio,
        'vehiculoId': vehiculoId,
      };
}
