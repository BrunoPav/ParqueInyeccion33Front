import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/shared.dart';
import '../../../vehiculos/dominio/vehiculo.dart';
import '../../dominio/servicio.dart';
import '../proveedores/servicios_proveedores.dart';
import '../widgets/resumen_servicios.dart';
import '../widgets/tarjeta_servicio.dart';
import 'formulario_servicio.dart';

class PantallaServicios extends ConsumerWidget {
  final Vehiculo vehiculo;

  const PantallaServicios({super.key, required this.vehiculo});

  Future<void> _abrirFormulario(
    BuildContext context,
    WidgetRef ref, {
    Servicio? servicio,
  }) async {
    final guardado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => FormularioServicio(
          vehiculoId: vehiculo.id!,
          servicio: servicio,
        ),
      ),
    );
    if (guardado == true) {
      ref.invalidate(serviciosPorVehiculoProvider(vehiculo.id!));
    }
  }

  Future<void> _eliminar(
    BuildContext context,
    WidgetRef ref,
    Servicio servicio,
  ) async {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicios = ref.watch(serviciosPorVehiculoProvider(vehiculo.id!));

    return Scaffold(
      appBar: AppBar(
        title: Text(vehiculo.descripcionCorta),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(24),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('Historial de ${vehiculo.patente}'),
          ),
        ),
      ),
      body: VistaAsync<List<Servicio>>(
        valor: servicios,
        alReintentar: () =>
            ref.invalidate(serviciosPorVehiculoProvider(vehiculo.id!)),
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
                      alEditar: () => _abrirFormulario(context, ref, servicio: servicio),
                      alEliminar: () => _eliminar(context, ref, servicio),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo servicio'),
      ),
    );
  }
}
