import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/ajustes/presentacion/pantallas/pantalla_ajustes.dart';
import '../../features/clientes/dominio/cliente.dart';
import '../../features/clientes/presentacion/pantallas/formulario_cliente.dart';
import '../../features/clientes/presentacion/pantallas/pantalla_clientes.dart';
import '../../features/clientes/presentacion/proveedores/clientes_proveedores.dart';
import '../../features/servicios/dominio/servicio.dart';
import '../../features/servicios/presentacion/pantallas/formulario_servicio.dart';
import '../../features/servicios/presentacion/pantallas/pantalla_servicios.dart';
import '../../features/servicios/presentacion/proveedores/servicios_proveedores.dart';
import '../../features/sesion/presentacion/pantallas/pantalla_login.dart';
import '../../features/vehiculos/dominio/vehiculo.dart';
import '../../features/vehiculos/presentacion/pantallas/formulario_vehiculo.dart';
import '../../features/vehiculos/presentacion/pantallas/pantalla_vehiculos.dart';
import '../../features/vehiculos/presentacion/pantallas/pantalla_vehiculos_global.dart';
import '../../features/vehiculos/presentacion/proveedores/vehiculos_proveedores.dart';
import '../../shared/widgets/retroalimentacion/pantalla_no_encontrada.dart';
import '../design_system/tokens/duraciones.dart';
import '../layout/andamio_adaptativo.dart';
import 'resolver_por_id.dart';
import 'rutas.dart';

int? _idDesdeRuta(GoRouterState state, String nombre) {
  return int.tryParse(state.pathParameters[nombre] ?? '');
}

/// Sin animación en web (se siente lenta ahí); `fade` en el resto.
Page<void> _pagina(Widget child) {
  return CustomTransitionPage<void>(
    child: child,
    transitionDuration: kIsWeb ? Duration.zero : Duraciones.normal,
    transitionsBuilder: (context, animation, secondaryAnimation, hijo) {
      if (kIsWeb) return hijo;
      return FadeTransition(opacity: animation, child: hijo);
    },
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Rutas.clientes,
    errorBuilder: (context, state) => const PantallaNoEncontrada(),
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AndamioAdaptativo(
            rutaActual: state.uri.toString(),
            alSeleccionarDestino: (ruta) => context.go(ruta),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: Rutas.clientes,
            pageBuilder: (context, state) => _pagina(const PantallaClientes()),
          ),
          GoRoute(
            path: Rutas.vehiculos,
            pageBuilder: (context, state) {
              final clienteId = _idDesdeRuta(state, 'clienteId');
              if (clienteId == null) return _pagina(const PantallaNoEncontrada());
              return _pagina(
                PantallaVehiculos(clienteId: clienteId, clienteExtra: state.extra as Cliente?),
              );
            },
          ),
          GoRoute(
            path: Rutas.servicios,
            pageBuilder: (context, state) {
              final clienteId = _idDesdeRuta(state, 'clienteId');
              final vehiculoId = _idDesdeRuta(state, 'vehiculoId');
              if (clienteId == null || vehiculoId == null) {
                return _pagina(const PantallaNoEncontrada());
              }
              return _pagina(
                PantallaServicios(
                  clienteId: clienteId,
                  vehiculoId: vehiculoId,
                  vehiculoExtra: state.extra as Vehiculo?,
                ),
              );
            },
          ),
          GoRoute(
            path: Rutas.vehiculosGlobal,
            pageBuilder: (context, state) => _pagina(const PantallaVehiculosGlobal()),
          ),
          GoRoute(
            path: Rutas.ajustes,
            pageBuilder: (context, state) => _pagina(const PantallaAjustes()),
          ),
          GoRoute(
            path: Rutas.login,
            pageBuilder: (context, state) => _pagina(const PantallaLogin()),
          ),
        ],
      ),
      GoRoute(
        path: Rutas.clienteNuevo,
        pageBuilder: (context, state) => _pagina(const FormularioCliente()),
      ),
      GoRoute(
        path: Rutas.clienteEditar,
        pageBuilder: (context, state) {
          final id = _idDesdeRuta(state, 'clienteId');
          if (id == null) return _pagina(const PantallaNoEncontrada());
          return _pagina(
            ResolverPorId<Cliente>(
              extra: state.extra as Cliente?,
              leer: (ref) => ref.watch(clientePorIdProvider(id)),
              reintentar: (ref) => ref.invalidate(clientePorIdProvider(id)),
              constructor: (cliente) => FormularioCliente(cliente: cliente),
            ),
          );
        },
      ),
      GoRoute(
        path: Rutas.vehiculoNuevo,
        pageBuilder: (context, state) {
          final clienteId = _idDesdeRuta(state, 'clienteId');
          if (clienteId == null) return _pagina(const PantallaNoEncontrada());
          return _pagina(FormularioVehiculo(clienteId: clienteId));
        },
      ),
      GoRoute(
        path: Rutas.vehiculoEditar,
        pageBuilder: (context, state) {
          final clienteId = _idDesdeRuta(state, 'clienteId');
          final vehiculoId = _idDesdeRuta(state, 'vehiculoId');
          if (clienteId == null || vehiculoId == null) {
            return _pagina(const PantallaNoEncontrada());
          }
          return _pagina(
            ResolverPorId<Vehiculo>(
              extra: state.extra as Vehiculo?,
              leer: (ref) => ref.watch(vehiculoPorIdProvider(vehiculoId)),
              reintentar: (ref) => ref.invalidate(vehiculoPorIdProvider(vehiculoId)),
              constructor: (vehiculo) => FormularioVehiculo(
                clienteId: clienteId,
                vehiculo: vehiculo,
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: Rutas.servicioNuevo,
        pageBuilder: (context, state) {
          final vehiculoId = _idDesdeRuta(state, 'vehiculoId');
          if (vehiculoId == null) return _pagina(const PantallaNoEncontrada());
          return _pagina(FormularioServicio(vehiculoId: vehiculoId));
        },
      ),
      GoRoute(
        path: Rutas.servicioEditar,
        pageBuilder: (context, state) {
          final vehiculoId = _idDesdeRuta(state, 'vehiculoId');
          final servicioId = _idDesdeRuta(state, 'servicioId');
          if (vehiculoId == null || servicioId == null) {
            return _pagina(const PantallaNoEncontrada());
          }
          return _pagina(
            ResolverPorId<Servicio>(
              extra: state.extra as Servicio?,
              leer: (ref) => ref.watch(servicioPorIdProvider(servicioId)),
              reintentar: (ref) => ref.invalidate(servicioPorIdProvider(servicioId)),
              constructor: (servicio) => FormularioServicio(
                vehiculoId: vehiculoId,
                servicio: servicio,
              ),
            ),
          );
        },
      ),
    ],
  );
});
