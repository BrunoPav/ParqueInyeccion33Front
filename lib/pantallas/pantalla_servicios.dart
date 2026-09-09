import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../estado/proveedores.dart';
import '../modelos/servicio.dart';
import '../modelos/vehiculo.dart';
import '../widgets/vista_async.dart';
import 'formulario_servicio.dart';

class PantallaServicios extends ConsumerWidget {
  final Vehiculo vehiculo;

  PantallaServicios({super.key, required this.vehiculo});

  final _formatoFecha = DateFormat('dd/MM/yyyy');

  String _precio(double valor) => '\$ ${valor.toStringAsFixed(2)}';

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
      await ref.read(apiServicioProvider).eliminar(servicio.id!);
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
              mensaje: 'Este vehiculo no tiene servicios registrados',
            );
          }

          final total = lista.fold<double>(0, (suma, s) => suma + s.precio);

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${lista.length} servicio${lista.length == 1 ? '' : 's'}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      'Total: ${_precio(total)}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: lista.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (_, indice) {
                    final servicio = lista[indice];
                    return ListTile(
                      isThreeLine: true,
                      leading: const CircleAvatar(child: Icon(Icons.build)),
                      title: Text(_formatoFecha.format(servicio.fecha)),
                      subtitle: Text(servicio.descripcion),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _precio(servicio.precio),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          PopupMenuButton<String>(
                            onSelected: (opcion) {
                              if (opcion == 'editar') {
                                _abrirFormulario(context, ref,
                                    servicio: servicio);
                              }
                              if (opcion == 'eliminar') {
                                _eliminar(context, ref, servicio);
                              }
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                  value: 'editar', child: Text('Editar')),
                              PopupMenuItem(
                                  value: 'eliminar', child: Text('Eliminar')),
                            ],
                          ),
                        ],
                      ),
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
