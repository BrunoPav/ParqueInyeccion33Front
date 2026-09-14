import 'package:taller_mecanico_frontend/features/clientes/dominio/cliente.dart';
import 'package:taller_mecanico_frontend/features/clientes/dominio/repositorio_clientes.dart';
import 'package:taller_mecanico_frontend/features/servicios/dominio/repositorio_servicios.dart';
import 'package:taller_mecanico_frontend/features/servicios/dominio/servicio.dart';
import 'package:taller_mecanico_frontend/features/vehiculos/dominio/repositorio_vehiculos.dart';
import 'package:taller_mecanico_frontend/features/vehiculos/dominio/vehiculo.dart';

class RepositorioClientesFalso implements RepositorioClientes {
  @override
  Future<List<Cliente>> listar({String? nombre, bool activo = true}) async {
    return const [
      Cliente(id: 1, nombre: 'Ana Gomez', contacto: '11-1111-1111'),
      Cliente(id: 2, nombre: 'Luis Diaz'),
    ];
  }

  @override
  Future<Cliente> obtener(int id) async => throw UnimplementedError();

  @override
  Future<Cliente> crear(Cliente cliente) async => throw UnimplementedError();

  @override
  Future<Cliente> reemplazar(int id, Cliente cliente) async => throw UnimplementedError();

  @override
  Future<Cliente> cambiarEstado(int id, bool activo) async => throw UnimplementedError();
}

class RepositorioClientesVacio implements RepositorioClientes {
  @override
  Future<List<Cliente>> listar({String? nombre, bool activo = true}) async => [];

  @override
  Future<Cliente> obtener(int id) async => throw UnimplementedError();

  @override
  Future<Cliente> crear(Cliente cliente) async => throw UnimplementedError();

  @override
  Future<Cliente> reemplazar(int id, Cliente cliente) async => throw UnimplementedError();

  @override
  Future<Cliente> cambiarEstado(int id, bool activo) async => throw UnimplementedError();
}

class RepositorioVehiculosFalso implements RepositorioVehiculos {
  @override
  Future<List<Vehiculo>> listar({int? clienteId}) async {
    return const [
      Vehiculo(
        id: 1,
        marca: 'Toyota',
        modelo: 'Hilux',
        anio: 2020,
        patente: 'AF320OK',
        kilometraje: 124500,
        clienteId: 1,
      ),
      Vehiculo(
        id: 2,
        marca: 'Volkswagen',
        modelo: 'Golf',
        anio: 2018,
        patente: 'AC712MN',
        kilometraje: 88200,
        clienteId: 1,
      ),
    ];
  }

  @override
  Future<Vehiculo> obtener(int id) async => throw UnimplementedError();

  @override
  Future<Vehiculo> porPatente(String patente) async => throw UnimplementedError();

  @override
  Future<Vehiculo> crear(Vehiculo vehiculo) async => throw UnimplementedError();

  @override
  Future<Vehiculo> reemplazar(int id, Vehiculo vehiculo) async => throw UnimplementedError();

  @override
  Future<void> eliminar(int id) async => throw UnimplementedError();
}

class RepositorioVehiculosVacio implements RepositorioVehiculos {
  @override
  Future<List<Vehiculo>> listar({int? clienteId}) async => [];

  @override
  Future<Vehiculo> obtener(int id) async => throw UnimplementedError();

  @override
  Future<Vehiculo> porPatente(String patente) async => throw UnimplementedError();

  @override
  Future<Vehiculo> crear(Vehiculo vehiculo) async => throw UnimplementedError();

  @override
  Future<Vehiculo> reemplazar(int id, Vehiculo vehiculo) async => throw UnimplementedError();

  @override
  Future<void> eliminar(int id) async => throw UnimplementedError();
}

class RepositorioServiciosFalso implements RepositorioServicios {
  @override
  Future<List<Servicio>> listar({int? vehiculoId}) async {
    return [
      Servicio(
        id: 1,
        fecha: DateTime(2025, 2, 12),
        descripcion: 'Mantenimiento programado 120k + frenos delanteros',
        precio: 148500,
        vehiculoId: 1,
      ),
      Servicio(
        id: 2,
        fecha: DateTime(2024, 8, 18),
        descripcion: 'Amortiguacion y tren delantero',
        precio: 92000,
        vehiculoId: 1,
      ),
    ];
  }

  @override
  Future<Servicio> obtener(int id) async => throw UnimplementedError();

  @override
  Future<Servicio> crear(Servicio servicio) async => throw UnimplementedError();

  @override
  Future<Servicio> reemplazar(int id, Servicio servicio) async => throw UnimplementedError();

  @override
  Future<void> eliminar(int id) async => throw UnimplementedError();
}

class RepositorioServiciosVacio implements RepositorioServicios {
  @override
  Future<List<Servicio>> listar({int? vehiculoId}) async => [];

  @override
  Future<Servicio> obtener(int id) async => throw UnimplementedError();

  @override
  Future<Servicio> crear(Servicio servicio) async => throw UnimplementedError();

  @override
  Future<Servicio> reemplazar(int id, Servicio servicio) async => throw UnimplementedError();

  @override
  Future<void> eliminar(int id) async => throw UnimplementedError();
}
