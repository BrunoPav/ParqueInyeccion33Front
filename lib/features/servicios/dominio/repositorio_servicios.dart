import 'servicio.dart';

abstract class RepositorioServicios {
  Future<List<Servicio>> listar({int? vehiculoId});
  Future<Servicio> obtener(int id);
  Future<Servicio> crear(Servicio servicio);
  Future<Servicio> reemplazar(int id, Servicio servicio);
  Future<void> eliminar(int id);
}
