import 'cliente.dart';

typedef FiltroClientes = ({String nombre, bool activo});

abstract class RepositorioClientes {
  Future<List<Cliente>> listar({String? nombre, bool activo = true});
  Future<Cliente> obtener(int id);
  Future<Cliente> crear(Cliente cliente);
  Future<Cliente> reemplazar(int id, Cliente cliente);
  Future<Cliente> cambiarEstado(int id, bool activo);
}
