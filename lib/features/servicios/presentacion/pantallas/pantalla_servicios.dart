import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/layout/contenedor_contenido.dart';
import '../../../../core/layout/contexto_layout.dart';
import '../../../../core/layout/panel_maestro_detalle.dart';
import '../../../../core/routing/rutas.dart';
import '../../../../shared/shared.dart';
import '../../../vehiculos/dominio/vehiculo.dart';
import '../../../vehiculos/presentacion/proveedores/vehiculos_proveedores.dart';
import '../../../vehiculos/presentacion/widgets/lista_vehiculos_maestro.dart';
import '../../dominio/servicio.dart';
import '../proveedores/servicios_proveedores.dart';
import '../widgets/resumen_servicios.dart';
import '../widgets/tarjeta_servicio.dart';

class PantallaServicios extends ConsumerWidget {
  final int clienteId;
  final int vehiculoId;
  final Vehiculo? vehiculoExtra;

  const PantallaServicios({
    super.key,
    required this.clienteId,
    required this.vehiculoId,
    this.vehiculoExtra,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final extra = vehiculoExtra;
    if (extra != null) {
      return _ContenidoServicios(clienteId: clienteId, vehiculo: extra);
    }

    final vehiculoAsync = ref.watch(vehiculoPorIdProvider(vehiculoId));
    return VistaAsync<Vehiculo>(
      valor: vehiculoAsync,
      alReintentar: () => ref.invalidate(vehiculoPorIdProvider(vehiculoId)),
      enDatos: (vehiculo) => _ContenidoServicios(clienteId: clienteId, vehiculo: vehiculo),
    );
  }
}

class _ContenidoServicios extends ConsumerWidget {
  final int clienteId;
  final Vehiculo vehiculo;

  const _ContenidoServicios({required this.clienteId, required this.vehiculo});

  Future<void> _eliminar(BuildContext context, WidgetRef ref, Servicio servicio) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (dialogo) => AlertDialog(
        title: const Text('Eliminar servicio'),
        content: const Text(
          'Se va a eliminar este servicio del historial. '
          'Esta accion no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogo).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogo).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmado != true) return;

    try {
      await ref.read(repositorioServiciosProvider).eliminar(servicio.id!);
      ref.invalidate(serviciosPorVehiculoProvider(vehiculo.id!));
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _irAServicios(BuildContext context, Vehiculo otroVehiculo) {
    final ruta = rutaServicios(clienteId, otroVehiculo.id!);
    context.go(ruta, extra: otroVehiculo);
  }

  Widget _historialServicios(BuildContext context, WidgetRef ref, AsyncValue<List<Servicio>> servicios) {
    return VistaAsync<List<Servicio>>(
      valor: servicios,
      alReintentar: () => ref.invalidate(serviciosPorVehiculoProvider(vehiculo.id!)),
      enDatos: (lista) {
        if (lista.isEmpty) {
          return const VistaVacia(
            icono: Icons.build_outlined,
            titulo: 'Este vehiculo no tiene servicios registrados',
          );
        }

        return Column(
          children: [
            ResumenServicios(servicios: lista),
            Expanded(
              child: ListView.separated(
                itemCount: lista.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (_, indice) {
                  final servicio = lista[indice];
                  return TarjetaServicio(
                    servicio: servicio,
                    alEditar: () => context.push(
                      rutaServicioEditar(clienteId, vehiculo.id!, servicio.id!),
                      extra: servicio,
                    ),
                    alEliminar: () => _eliminar(context, ref, servicio),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicios = ref.watch(serviciosPorVehiculoProvider(vehiculo.id!));

    return Scaffold(
      appBar: AppBar(
        title: Text(vehiculo.descripcionCorta),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(24),
          child: Padding(
            padding: EdgeInsets.only(bottom: context.espaciado.xs),
            child: Text('Historial de ${vehiculo.patente}'),
          ),
        ),
      ),
      body: context.esCompacto
          ? _historialServicios(context, ref, servicios)
          : ContenedorContenido(
              child: PanelMaestroDetalle(
                maestro: ListaVehiculosMaestro(
                  clienteId: clienteId,
                  vehiculoSeleccionadoId: vehiculo.id,
                  alSeleccionar: _irAServicios,
                ),
                detalle: _historialServicios(context, ref, servicios),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(rutaServicioNuevo(clienteId, vehiculo.id!)),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo servicio'),
      ),
    );
  }
}
