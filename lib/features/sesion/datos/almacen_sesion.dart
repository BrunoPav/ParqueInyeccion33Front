import 'package:shared_preferences/shared_preferences.dart';

import '../dominio/sesion.dart';

class AlmacenSesion {
  static const _claveToken = 'sesion.token';
  static const _claveUsuario = 'sesion.usuario';
  static const _claveRol = 'sesion.rol';

  final SharedPreferences _preferencias;

  const AlmacenSesion(this._preferencias);

  Sesion? leer() {
    final token = _preferencias.getString(_claveToken);
    final usuario = _preferencias.getString(_claveUsuario);
    if (token == null || usuario == null) return null;

    return Sesion(
      token: token,
      nombreUsuario: usuario,
      rol: _preferencias.getString(_claveRol) == 'ADMIN' ? Rol.admin : Rol.demo,
    );
  }

  Future<void> guardar(Sesion sesion) async {
    await _preferencias.setString(_claveToken, sesion.token);
    await _preferencias.setString(_claveUsuario, sesion.nombreUsuario);
    await _preferencias.setString(
      _claveRol,
      sesion.rol == Rol.admin ? 'ADMIN' : 'DEMO',
    );
  }

  Future<void> borrar() async {
    await _preferencias.remove(_claveToken);
    await _preferencias.remove(_claveUsuario);
    await _preferencias.remove(_claveRol);
  }
}
