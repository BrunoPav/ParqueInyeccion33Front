import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/rutas.dart';
import '../../../../shared/shared.dart';
import '../../dominio/cliente.dart';
import '../../dominio/repositorio_clientes.dart';
import '../proveedores/clientes_proveedores.dart';
import '../widgets/tarjeta_cliente.dart';

class PantallaClientes extends ConsumerStatefulWidget {
  const PantallaClientes({super.key});

  @override
  ConsumerState<PantallaClientes> createState() => _PantallaClientesState();
}

class _PantallaClientesState extends ConsumerState<PantallaClientes> {
  final _busqueda = TextEditingController();
  String _nombreFiltro = '';
  bool _mostrarActivos = true;

  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  FiltroClientes get _filtro => (nombre: _nombreFiltro, activo: _mostrarActivos);

  Future<void> _cambiarEstado(Cliente cliente) async {
    try {
      await ref
          .read(repositorioClientesProvider)
          .cambiarEstado(cliente.id!, !cliente.activo);
      ref.invalidate(clientesProvider);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientes = ref.watch(clientesProvider(_filtro));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(clientesProvider),
          ),
          IconButton(
            tooltip: 'Ajustes',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(Rutas.ajustes),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _busqueda,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                isDense: true,
                suffixIcon: _nombreFiltro.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _busqueda.clear();
                          setState(() => _nombreFiltro = '');
                        },
                      ),
              ),
              onSubmitted: (valor) =>
                  setState(() => _nombreFiltro = valor.trim()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Activos'),
                  selected: _mostrarActivos,
                  onSelected: (_) => setState(() => _mostrarActivos = true),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Inactivos'),
                  selected: !_mostrarActivos,
                  onSelected: (_) => setState(() => _mostrarActivos = false),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: VistaAsync<List<Cliente>>(
              valor: clientes,
              alReintentar: () => ref.invalidate(clientesProvider),
              enDatos: (lista) {
                if (lista.isEmpty) {
                  return VistaVacia(
                    icono: Icons.people_outline,
                    titulo: _mostrarActivos
                        ? 'No hay clientes activos'
                        : 'No hay clientes inactivos',
                  );
                }
                return ListView.separated(
                  itemCount: lista.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (_, indice) {
                    final cliente = lista[indice];
                    return TarjetaCliente(
                      cliente: cliente,
                      alTocar: () => context.push(
                        rutaVehiculos(cliente.id!),
                        extra: cliente,
                      ),
                      alEditar: () => context.push(
                        rutaClienteEditar(cliente.id!),
                        extra: cliente,
                      ),
                      alCambiarEstado: () => _cambiarEstado(cliente),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Rutas.clienteNuevo),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo cliente'),
      ),
    );
  }
}
