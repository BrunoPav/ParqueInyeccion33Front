import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_cliente.dart';
import '../api/api_servicio.dart';
import '../api/api_vehiculo.dart';
import '../modelos/cliente.dart';
import '../modelos/servicio.dart';
import '../modelos/vehiculo.dart';

typedef FiltroClientes = ({String nombre, bool activo});

final apiClienteProvider = Provider<ApiCliente>((ref) => ApiCliente());
final apiVehiculoProvider = Provider<ApiVehiculo>((ref) => ApiVehiculo());
final apiServicioProvider = Provider<ApiServicio>((ref) => ApiServicio());

final clientesProvider =
    FutureProvider.family<List<Cliente>, FiltroClientes>((ref, filtro) {
  return ref.read(apiClienteProvider).listar(
        nombre: filtro.nombre.isEmpty ? null : filtro.nombre,
        activo: filtro.activo,
      );
});

final vehiculosPorClienteProvider =
    FutureProvider.family<List<Vehiculo>, int>((ref, clienteId) {
  return ref.read(apiVehiculoProvider).listar(clienteId: clienteId);
});

final serviciosPorVehiculoProvider =
    FutureProvider.family<List<Servicio>, int>((ref, vehiculoId) {
  return ref.read(apiServicioProvider).listar(vehiculoId: vehiculoId);
});
