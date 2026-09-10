import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../estado/proveedores.dart';
import '../features/ajustes/presentacion/pantallas/pantalla_ajustes.dart';
import '../modelos/cliente.dart';
import '../widgets/vista_async.dart';
import 'formulario_cliente.dart';
import 'pantalla_vehiculos.dart';

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

  Future<void> _abrirFormulario({Cliente? cliente}) async {
    final guardado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => FormularioCliente(cliente: cliente)),
    );
    if (guardado == true) {
      ref.invalidate(clientesProvider);
    }
  }

  Future<void> _cambiarEstado(Cliente cliente) async {
    try {
      await ref
          .read(apiClienteProvider)
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
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PantallaAjustes()),
            ),
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
                    mensaje: _mostrarActivos
                        ? 'No hay clientes activos'
                        : 'No hay clientes inactivos',
                  );
                }
                return ListView.separated(
                  itemCount: lista.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (_, indice) =>
                      _FilaCliente(
                        cliente: lista[indice],
                        alEditar: () => _abrirFormulario(cliente: lista[indice]),
                        alCambiarEstado: () => _cambiarEstado(lista[indice]),
                      ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo cliente'),
      ),
    );
  }
}

class _FilaCliente extends StatelessWidget {
  final Cliente cliente;
  final VoidCallback alEditar;
  final VoidCallback alCambiarEstado;

  const _FilaCliente({
    required this.cliente,
    required this.alEditar,
    required this.alCambiarEstado,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          cliente.nombre.isEmpty ? '?' : cliente.nombre[0].toUpperCase(),
        ),
      ),
      title: Text(cliente.nombre),
      subtitle: Text(
        cliente.contacto?.isNotEmpty == true ? cliente.contacto! : 'Sin contacto',
      ),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => PantallaVehiculos(cliente: cliente)),
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (opcion) {
          if (opcion == 'editar') alEditar();
          if (opcion == 'estado') alCambiarEstado();
        },
        itemBuilder: (_) => [
          const PopupMenuItem(value: 'editar', child: Text('Editar')),
          PopupMenuItem(
            value: 'estado',
            child: Text(cliente.activo ? 'Desactivar' : 'Activar'),
          ),
        ],
      ),
    );
  }
}
