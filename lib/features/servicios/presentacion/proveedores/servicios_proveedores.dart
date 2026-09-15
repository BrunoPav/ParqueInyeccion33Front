import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../datos/fuente_remota_servicios.dart';
import '../../datos/repositorio_servicios_http.dart';
import '../../dominio/repositorio_servicios.dart';
import '../../dominio/servicio.dart';

final repositorioServiciosProvider = Provider<RepositorioServicios>((ref) {
  return RepositorioServiciosHttp(FuenteRemotaServicios());
});

final serviciosPorVehiculoProvider = FutureProvider.family<List<Servicio>, int>((ref, vehiculoId) {
  return ref.watch(repositorioServiciosProvider).listar(vehiculoId: vehiculoId);
});

final servicioPorIdProvider = FutureProvider.family<Servicio, int>((ref, id) {
  return ref.watch(repositorioServiciosProvider).obtener(id);
});
