enum Rol { demo, admin }

class Sesion {
  final String token;
  final String nombreUsuario;
  final Rol rol;

  const Sesion({
    required this.token,
    required this.nombreUsuario,
    required this.rol,
  });

  bool get puedeBorrar => rol == Rol.admin;
}
