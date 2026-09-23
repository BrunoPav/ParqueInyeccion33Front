import '../dominio/sesion.dart';

class SesionDto {
  final String token;
  final String nombreUsuario;
  final String rol;

  const SesionDto({
    required this.token,
    required this.nombreUsuario,
    required this.rol,
  });

  factory SesionDto.desdeJson(Map<String, dynamic> json) => SesionDto(
    token: json['token'] as String,
    nombreUsuario: json['nombreUsuario'] as String,
    rol: json['rol'] as String? ?? 'DEMO',
  );

  Sesion aDominio() => Sesion(
    token: token,
    nombreUsuario: nombreUsuario,
    rol: rol.toUpperCase() == 'ADMIN' ? Rol.admin : Rol.demo,
  );
}
