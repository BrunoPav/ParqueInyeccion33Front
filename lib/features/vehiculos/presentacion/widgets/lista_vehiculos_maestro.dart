import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/rutas.dart';
import '../../../../shared/shared.dart';
import '../../dominio/vehiculo.dart';
import '../proveedores/vehiculos_proveedores.dart';
import 'tarjeta_vehiculo.dart';

/// Panel maestro compartido por `PantallaVehiculos` y `PantallaServicios`;
/// [vehiculoSeleccionadoId] resalta la fila cuando ya hay uno elegido.
class ListaVehiculosMaestro extends ConsumerWidget {
  final int clienteId;
  final int? vehiculoSeleccionadoId;
  final void Function(BuildContext context, Vehiculo vehiculo) alSeleccionar;

  const ListaVehiculosMaestro({
    super.key,
    required this.clienteId,
    this.vehiculoSeleccionadoId,
    required this.alSeleccionar,
  });

  Future<void> _eliminar(BuildContext context, WidgetRef ref, Vehiculo vehiculo) async {
    final confirmado = await dialogoConfirmacion(
      context,
      titulo: 'Eliminar vehiculo',
      cuerpo: 'Se va a eliminar ${vehiculo.descripcionCorta} y todos sus servicios. '
          'Esta accion no se puede deshacer.',
      etiquetaConfirmar: 'Eliminar',
      destructivo: true,
    );
    if (!confirmado) return;

    try {
      await ref.read(repositorioVehiculosProvider).eliminar(vehiculo.id!);
      ref.invalidate(vehiculosPorClienteProvider(clienteId));
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehiculos = ref.watch(vehiculosPorClienteProvider(clienteId));

    return VistaAsync<List<Vehiculo>>(
      valor: vehiculos,
      alReintentar: () => ref.invalidate(vehiculosPorClienteProvider(clienteId)),
      enDatos: (lista) {
        if (lista.isEmpty) {
          return const VistaVacia(
            icono: Icons.directions_car_outlined,
            titulo: 'Este cliente no tiene vehiculos',
          );
        }
        return ListView.separated(
          itemCount: lista.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (_, indice) {
            final vehiculo = lista[indice];
            return TarjetaVehiculo(
              vehiculo: vehiculo,
              seleccionado: vehiculo.id == vehiculoSeleccionadoId,
              alTocar: () => alSeleccionar(context, vehiculo),
              alEditar: () => context.push(
                rutaVehiculoEditar(clienteId, vehiculo.id!),
                extra: vehiculo,
              ),
              alEliminar: () => _eliminar(context, ref, vehiculo),
            );
          },
        );
      },
    );
  }
}
