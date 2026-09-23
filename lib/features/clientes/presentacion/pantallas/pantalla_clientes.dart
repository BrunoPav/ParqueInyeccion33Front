import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/layout/contenedor_contenido.dart';
import '../../../../core/layout/contexto_layout.dart';
import '../../../../core/layout/panel_maestro_detalle.dart';
import '../../../../core/routing/rutas.dart';
import '../../../../features/sesion/presentacion/widgets/accion_sesion.dart';
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
  String _nombreFiltro = '';
  bool _mostrarActivos = true;

  FiltroClientes get _filtro => (nombre: _nombreFiltro, activo: _mostrarActivos);

  Future<void> _cambiarEstado(Cliente cliente) async {
    try {
      await ref.read(repositorioClientesProvider).cambiarEstado(cliente.id!, !cliente.activo);
      ref.invalidate(clientesProvider);
    } catch (error) {
      if (!mounted) return;
      Notificador.errorDeApi(context, error);
    }
  }

  void _irAVehiculos(BuildContext context, Cliente cliente) {
    final ruta = rutaVehiculos(cliente.id!);
    if (context.esCompacto) {
      context.push(ruta, extra: cliente);
    } else {
      context.go(ruta, extra: cliente);
    }
  }

  Widget _listaClientes(BuildContext context, AsyncValue<List<Cliente>> clientes) {
    // Fuera de compacto, ContenedorContenido ya pone el margen de borde de
    // pantalla; acá adentro (columna maestra de 360px) alcanza con espaciado
    // interno, sino queda doble margen a la izquierda.
    final horizontal = context.esCompacto ? context.bordePantalla : context.espaciado.md;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            horizontal,
            context.espaciado.sm,
            horizontal,
            context.espaciado.xs,
          ),
          child: BotonPrimario(
            etiqueta: 'Nuevo cliente',
            icono: Icons.add,
            onPressed: () => context.push(Rutas.clienteNuevo),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            horizontal,
            context.espaciado.xs,
            horizontal,
            context.espaciado.xs,
          ),
          child: BarraBusqueda(
            sugerencia: 'Buscar por nombre',
            onBuscar: (valor) => setState(() => _nombreFiltro = valor),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontal),
          child: Wrap(
            spacing: context.espaciado.xs,
            runSpacing: context.espaciado.xs,
            children: [
              FilterChip(
                label: const Text('Activos'),
                selected: _mostrarActivos,
                onSelected: (_) => setState(() => _mostrarActivos = true),
              ),
              FilterChip(
                label: const Text('Inactivos'),
                selected: !_mostrarActivos,
                onSelected: (_) => setState(() => _mostrarActivos = false),
              ),
            ],
          ),
        ),
        SizedBox(height: context.espaciado.xs),
        Expanded(
          child: VistaAsync<List<Cliente>>(
            valor: clientes,
            alReintentar: () => ref.invalidate(clientesProvider),
            cargando: ListView.builder(
              itemCount: 6,
              itemBuilder: (_, _) => const EsqueletoFilaLista(),
            ),
            enDatos: (lista) {
              if (lista.isEmpty) {
                return VistaVacia(
                  icono: Icons.people_outline,
                  titulo: _mostrarActivos
                      ? 'No hay clientes activos'
                      : 'No hay clientes inactivos',
                  etiquetaAccion: _mostrarActivos ? 'Crear el primer cliente' : null,
                  onAccion: _mostrarActivos ? () => context.push(Rutas.clienteNuevo) : null,
                );
              }
              return RefreshIndicator(
                onRefresh: () async => ref.invalidate(clientesProvider),
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: horizontal),
                  itemCount: lista.length,
                  separatorBuilder: (_, _) => SizedBox(height: context.espaciado.separacionLista),
                  itemBuilder: (_, indice) {
                    final cliente = lista[indice];
                    return TarjetaCliente(
                      cliente: cliente,
                      alTocar: () => _irAVehiculos(context, cliente),
                      alEditar: () => context.push(
                        rutaClienteEditar(cliente.id!),
                        extra: cliente,
                      ),
                      alCambiarEstado: () => _cambiarEstado(cliente),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final clientes = ref.watch(clientesProvider(_filtro));
    final esCompacto = context.esCompacto;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(clientesProvider),
          ),
          const AccionSesion(),
        ],
      ),
      body: esCompacto
          ? _listaClientes(context, clientes)
          : ContenedorContenido(
              child: PanelMaestroDetalle(
                maestro: _listaClientes(context, clientes),
                detalle: const VistaVacia(
                  icono: Icons.directions_car_outlined,
                  titulo: 'Seleccioná un cliente',
                  textoApoyo: 'Elegí un cliente de la lista para ver sus vehículos.',
                ),
              ),
            ),
    );
  }
}
