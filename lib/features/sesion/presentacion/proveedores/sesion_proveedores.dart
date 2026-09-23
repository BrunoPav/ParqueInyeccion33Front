import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/red/cliente_http.dart';
import '../../../ajustes/datos/preferencias.dart';
import '../../datos/almacen_sesion.dart';
import '../../datos/fuente_remota_sesion.dart';
import '../../dominio/sesion.dart';

final almacenSesionProvider = Provider<AlmacenSesion>((ref) {
  return AlmacenSesion(ref.watch(preferenciasProvider));
});

final fuenteRemotaSesionProvider = Provider<FuenteRemotaSesion>((ref) {
  return FuenteRemotaSesion();
});

class SesionNotifier extends Notifier<Sesion?> {
  @override
  Sesion? build() {
    final guardada = ref.read(almacenSesionProvider).leer();
    establecerToken(guardada?.token);
    return guardada;
  }

  Future<void> iniciarSesion(String nombreUsuario, String contrasena) async {
    final dto = await ref
        .read(fuenteRemotaSesionProvider)
        .iniciarSesion(nombreUsuario, contrasena);

    final sesion = dto.aDominio();
    establecerToken(sesion.token);
    await ref.read(almacenSesionProvider).guardar(sesion);
    state = sesion;
  }

  Future<void> cerrarSesion() async {
    establecerToken(null);
    await ref.read(almacenSesionProvider).borrar();
    state = null;
  }
}

final sesionProvider = NotifierProvider<SesionNotifier, Sesion?>(
  SesionNotifier.new,
);

final haySesionProvider = Provider<bool>((ref) {
  return ref.watch(sesionProvider) != null;
});

final puedeBorrarProvider = Provider<bool>((ref) {
  return ref.watch(sesionProvider)?.puedeBorrar ?? false;
});
