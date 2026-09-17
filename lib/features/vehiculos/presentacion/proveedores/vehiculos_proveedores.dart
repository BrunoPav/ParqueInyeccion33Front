import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../datos/fuente_remota_vehiculos.dart';
import '../../datos/repositorio_vehiculos_http.dart';
import '../../dominio/repositorio_vehiculos.dart';
import '../../dominio/vehiculo.dart';

final repositorioVehiculosProvider = Provider<RepositorioVehiculos>((ref) {
  return RepositorioVehiculosHttp(FuenteRemotaVehiculos());
});

final vehiculosPorClienteProvider = FutureProvider.family<List<Vehiculo>, int>((ref, clienteId) {
  return ref.watch(repositorioVehiculosProvider).listar(clienteId: clienteId);
});

final vehiculoPorIdProvider = FutureProvider.family<Vehiculo, int>((ref, id) {
  return ref.watch(repositorioVehiculosProvider).obtener(id);
});

/// Todos los vehículos, sin filtrar por cliente — F9.37.
final vehiculosGlobalProvider = FutureProvider<List<Vehiculo>>((ref) {
  return ref.watch(repositorioVehiculosProvider).listar();
});

final vehiculoPorPatenteProvider = FutureProvider.family<Vehiculo, String>((ref, patente) {
  return ref.watch(repositorioVehiculosProvider).porPatente(patente);
});
