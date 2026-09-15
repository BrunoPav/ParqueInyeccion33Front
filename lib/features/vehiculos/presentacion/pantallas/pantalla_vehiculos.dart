import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/layout/contenedor_contenido.dart';
import '../../../../core/layout/contexto_layout.dart';
import '../../../../core/layout/panel_maestro_detalle.dart';
import '../../../../core/routing/rutas.dart';
import '../../../../shared/shared.dart';
import '../../../clientes/dominio/cliente.dart';
import '../../../clientes/presentacion/proveedores/clientes_proveedores.dart';
import '../../dominio/vehiculo.dart';
import '../widgets/lista_vehiculos_maestro.dart';

class PantallaVehiculos extends ConsumerWidget {
  final int clienteId;
  final Cliente? clienteExtra;

  const PantallaVehiculos({super.key, required this.clienteId, this.clienteExtra});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final extra = clienteExtra;
    if (extra != null) {
      return _ContenidoVehiculos(cliente: extra);
    }

    final clienteAsync = ref.watch(clientePorIdProvider(clienteId));
    return VistaAsync<Cliente>(
      valor: clienteAsync,
      alReintentar: () => ref.invalidate(clientePorIdProvider(clienteId)),
      enDatos: (cliente) => _ContenidoVehiculos(cliente: cliente),
    );
  }
}

class _ContenidoVehiculos extends StatelessWidget {
  final Cliente cliente;

  const _ContenidoVehiculos({required this.cliente});

  void _irAServicios(BuildContext context, Vehiculo vehiculo) {
    final ruta = rutaServicios(cliente.id!, vehiculo.id!);
    if (context.esCompacto) {
      context.push(ruta, extra: vehiculo);
    } else {
      context.go(ruta, extra: vehiculo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lista = ListaVehiculosMaestro(
      clienteId: cliente.id!,
      alSeleccionar: _irAServicios,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(cliente.nombre),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(24),
          child: Padding(
            padding: EdgeInsets.only(bottom: context.espaciado.xs),
            child: const Text('Vehiculos'),
          ),
        ),
      ),
      body: context.esCompacto
          ? lista
          : ContenedorContenido(
              child: PanelMaestroDetalle(
                maestro: lista,
                detalle: const VistaVacia(
                  icono: Icons.build_outlined,
                  titulo: 'Seleccioná un vehículo',
                  textoApoyo: 'Elegí un vehículo de la lista para ver sus servicios.',
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(rutaVehiculoNuevo(cliente.id!)),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo vehiculo'),
      ),
    );
  }
}
