import '../dominio/repositorio_servicios.dart';
import '../dominio/servicio.dart';
import 'fuente_remota_servicios.dart';
import 'servicio_dto.dart';

class RepositorioServiciosHttp implements RepositorioServicios {
  final FuenteRemotaServicios _fuente;

  const RepositorioServiciosHttp(this._fuente);

  @override
  Future<List<Servicio>> listar({int? vehiculoId}) async {
    final dtos = await _fuente.listar(vehiculoId: vehiculoId);
    return dtos.map((dto) => dto.aDominio()).toList();
  }

  @override
  Future<Servicio> obtener(int id) async {
    return (await _fuente.obtener(id)).aDominio();
  }

  @override
  Future<Servicio> crear(Servicio servicio) async {
    final creado = await _fuente.crear(ServicioDto.desdeDominio(servicio));
    return creado.aDominio();
  }

  @override
  Future<Servicio> reemplazar(int id, Servicio servicio) async {
    final actualizado = await _fuente.reemplazar(id, ServicioDto.desdeDominio(servicio));
    return actualizado.aDominio();
  }

  @override
  Future<void> eliminar(int id) => _fuente.eliminar(id);
}
