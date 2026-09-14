import '../dominio/cliente.dart';
import '../dominio/repositorio_clientes.dart';
import 'cliente_dto.dart';
import 'fuente_remota_clientes.dart';

class RepositorioClientesHttp implements RepositorioClientes {
  final FuenteRemotaClientes _fuente;

  const RepositorioClientesHttp(this._fuente);

  @override
  Future<List<Cliente>> listar({String? nombre, bool activo = true}) async {
    final dtos = await _fuente.listar(nombre: nombre, activo: activo);
    return dtos.map((dto) => dto.aDominio()).toList();
  }

  @override
  Future<Cliente> obtener(int id) async {
    return (await _fuente.obtener(id)).aDominio();
  }

  @override
  Future<Cliente> crear(Cliente cliente) async {
    final creado = await _fuente.crear(ClienteDto.desdeDominio(cliente));
    return creado.aDominio();
  }

  @override
  Future<Cliente> reemplazar(int id, Cliente cliente) async {
    final actualizado = await _fuente.reemplazar(id, ClienteDto.desdeDominio(cliente));
    return actualizado.aDominio();
  }

  @override
  Future<Cliente> cambiarEstado(int id, bool activo) async {
    return (await _fuente.cambiarEstado(id, activo)).aDominio();
  }
}
