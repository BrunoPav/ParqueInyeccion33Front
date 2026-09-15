abstract final class Rutas {
  static const clientes = '/clientes';
  static const clienteNuevo = '/clientes/nuevo';
  static const clienteEditar = '/clientes/:clienteId/editar';
  static const vehiculos = '/clientes/:clienteId/vehiculos';
  static const vehiculoNuevo = '/clientes/:clienteId/vehiculos/nuevo';
  static const vehiculoEditar = '/clientes/:clienteId/vehiculos/:vehiculoId/editar';
  static const servicios = '/clientes/:clienteId/vehiculos/:vehiculoId/servicios';
  static const servicioNuevo = '/clientes/:clienteId/vehiculos/:vehiculoId/servicios/nuevo';
  static const servicioEditar =
      '/clientes/:clienteId/vehiculos/:vehiculoId/servicios/:servicioId/editar';
  static const ajustes = '/ajustes';
}

String rutaClienteEditar(int clienteId) => '/clientes/$clienteId/editar';

String rutaVehiculos(int clienteId) => '/clientes/$clienteId/vehiculos';

String rutaVehiculoNuevo(int clienteId) => '/clientes/$clienteId/vehiculos/nuevo';

String rutaVehiculoEditar(int clienteId, int vehiculoId) =>
    '/clientes/$clienteId/vehiculos/$vehiculoId/editar';

String rutaServicios(int clienteId, int vehiculoId) =>
    '/clientes/$clienteId/vehiculos/$vehiculoId/servicios';

String rutaServicioNuevo(int clienteId, int vehiculoId) =>
    '/clientes/$clienteId/vehiculos/$vehiculoId/servicios/nuevo';

String rutaServicioEditar(int clienteId, int vehiculoId, int servicioId) =>
    '/clientes/$clienteId/vehiculos/$vehiculoId/servicios/$servicioId/editar';
