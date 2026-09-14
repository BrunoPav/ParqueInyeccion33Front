import 'vehiculo.dart';

abstract class RepositorioVehiculos {
  Future<List<Vehiculo>> listar({int? clienteId});
  Future<Vehiculo> obtener(int id);
  Future<Vehiculo> porPatente(String patente);
  Future<Vehiculo> crear(Vehiculo vehiculo);
  Future<Vehiculo> reemplazar(int id, Vehiculo vehiculo);
  Future<void> eliminar(int id);
}
