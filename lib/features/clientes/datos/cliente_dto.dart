import '../dominio/cliente.dart';

class ClienteDto {
  final int? id;
  final String nombre;
  final String? contacto;
  final bool activo;

  const ClienteDto({
    this.id,
    required this.nombre,
    this.contacto,
    this.activo = true,
  });

  factory ClienteDto.desdeJson(Map<String, dynamic> json) => ClienteDto(
        id: json['id'] as int?,
        nombre: json['nombre'] as String,
        contacto: json['contacto'] as String?,
        activo: json['activo'] as bool? ?? true,
      );

  factory ClienteDto.desdeDominio(Cliente cliente) => ClienteDto(
        id: cliente.id,
        nombre: cliente.nombre,
        contacto: cliente.contacto,
        activo: cliente.activo,
      );

  Map<String, dynamic> aJson() => {
        'nombre': nombre,
        'contacto': contacto,
      };

  Cliente aDominio() => Cliente(id: id, nombre: nombre, contacto: contacto, activo: activo);
}
