import '../dominio/repositorio_vehiculos.dart';
import '../dominio/vehiculo.dart';
import 'fuente_remota_vehiculos.dart';
import 'vehiculo_dto.dart';

class RepositorioVehiculosHttp implements RepositorioVehiculos {
  final FuenteRemotaVehiculos _fuente;

  const RepositorioVehiculosHttp(this._fuente);

  @override
  Future<List<Vehiculo>> listar({int? clienteId}) async {
    final dtos = await _fuente.listar(clienteId: clienteId);
    return dtos.map((dto) => dto.aDominio()).toList();
  }

  @override
  Future<Vehiculo> obtener(int id) async {
    return (await _fuente.obtener(id)).aDominio();
  }

  @override
  Future<Vehiculo> porPatente(String patente) async {
    return (await _fuente.porPatente(patente)).aDominio();
  }

  @override
  Future<Vehiculo> crear(Vehiculo vehiculo) async {
    final creado = await _fuente.crear(VehiculoDto.desdeDominio(vehiculo));
    return creado.aDominio();
  }

  @override
  Future<Vehiculo> reemplazar(int id, Vehiculo vehiculo) async {
    final actualizado = await _fuente.reemplazar(id, VehiculoDto.desdeDominio(vehiculo));
    return actualizado.aDominio();
  }

  @override
  Future<void> eliminar(int id) => _fuente.eliminar(id);
}
