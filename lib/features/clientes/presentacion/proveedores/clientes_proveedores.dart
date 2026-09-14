import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../datos/fuente_remota_clientes.dart';
import '../../datos/repositorio_clientes_http.dart';
import '../../dominio/cliente.dart';
import '../../dominio/repositorio_clientes.dart';

final repositorioClientesProvider = Provider<RepositorioClientes>((ref) {
  return RepositorioClientesHttp(FuenteRemotaClientes());
});

final clientesProvider = FutureProvider.family<List<Cliente>, FiltroClientes>((ref, filtro) {
  return ref.watch(repositorioClientesProvider).listar(
        nombre: filtro.nombre.isEmpty ? null : filtro.nombre,
        activo: filtro.activo,
      );
});

final clientePorIdProvider = FutureProvider.family<Cliente, int>((ref, id) {
  return ref.watch(repositorioClientesProvider).obtener(id);
});
