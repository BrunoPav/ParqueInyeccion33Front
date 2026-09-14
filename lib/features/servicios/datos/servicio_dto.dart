import '../dominio/servicio.dart';

class ServicioDto {
  final int? id;
  final DateTime fecha;
  final String descripcion;
  final double precio;
  final int vehiculoId;

  const ServicioDto({
    this.id,
    required this.fecha,
    required this.descripcion,
    required this.precio,
    required this.vehiculoId,
  });

  factory ServicioDto.desdeJson(Map<String, dynamic> json) => ServicioDto(
        id: json['id'] as int?,
        fecha: DateTime.parse(json['fecha'] as String),
        descripcion: json['descripcion'] as String,
        precio: (json['precio'] as num).toDouble(),
        vehiculoId: json['vehiculoId'] as int,
      );

  factory ServicioDto.desdeDominio(Servicio servicio) => ServicioDto(
        id: servicio.id,
        fecha: servicio.fecha,
        descripcion: servicio.descripcion,
        precio: servicio.precio,
        vehiculoId: servicio.vehiculoId,
      );

  Map<String, dynamic> aJson() => {
        'fecha': fecha.toIso8601String().split('T').first,
        'descripcion': descripcion,
        'precio': precio,
        'vehiculoId': vehiculoId,
      };

  Servicio aDominio() => Servicio(
        id: id,
        fecha: fecha,
        descripcion: descripcion,
        precio: precio,
        vehiculoId: vehiculoId,
      );
}
