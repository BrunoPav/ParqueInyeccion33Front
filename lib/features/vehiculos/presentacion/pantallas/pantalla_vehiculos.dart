import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/shared.dart';
import '../../../clientes/dominio/cliente.dart';
import '../../../servicios/presentacion/pantallas/pantalla_servicios.dart';
import '../../dominio/vehiculo.dart';
import '../proveedores/vehiculos_proveedores.dart';
import '../widgets/tarjeta_vehiculo.dart';
import 'formulario_vehiculo.dart';

class PantallaVehiculos extends ConsumerWidget {
  final Cliente cliente;

  const PantallaVehiculos({super.key, required this.cliente});

  Future<void> _abrirFormulario(
    BuildContext context,
    WidgetRef ref, {
    Vehiculo? vehiculo,
  }) async {
    final guardado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => FormularioVehiculo(
          clienteId: cliente.id!,
          vehiculo: vehiculo,
        ),
      ),
    );
    if (guardado == true) {
      ref.invalidate(vehiculosPorClienteProvider(cliente.id!));
    }
  }

  Future<void> _eliminar(
    BuildContext context,
    WidgetRef ref,
    Vehiculo vehiculo,
  ) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (dialogo) => AlertDialog(
        title: const Text('Eliminar vehiculo'),
        content: Text(
          'Se va a eliminar ${vehiculo.descripcionCorta} y todos sus servicios. '
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
      await ref.read(repositorioVehiculosProvider).eliminar(vehiculo.id!);
      ref.invalidate(vehiculosPorClienteProvider(cliente.id!));
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
    final vehiculos = ref.watch(vehiculosPorClienteProvider(cliente.id!));

    return Scaffold(
      appBar: AppBar(
        title: Text(cliente.nombre),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(24),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text('Vehiculos'),
          ),
        ),
      ),
      body: VistaAsync<List<Vehiculo>>(
        valor: vehiculos,
        alReintentar: () =>
            ref.invalidate(vehiculosPorClienteProvider(cliente.id!)),
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
                alTocar: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PantallaServicios(vehiculo: vehiculo),
                  ),
                ),
                alEditar: () => _abrirFormulario(context, ref, vehiculo: vehiculo),
                alEliminar: () => _eliminar(context, ref, vehiculo),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo vehiculo'),
      ),
    );
  }
}
