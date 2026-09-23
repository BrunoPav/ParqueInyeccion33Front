import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/layout/contenedor_contenido.dart';
import '../../../../core/red/excepciones.dart';
import '../../../../core/routing/rutas.dart';
import '../../../../shared/shared.dart';
import '../../dominio/vehiculo.dart';
import '../proveedores/vehiculos_proveedores.dart';
import '../widgets/tarjeta_vehiculo.dart';

/// Todos los vehículos, buscables por patente exacta sin pasar por su
/// cliente — F9.37 (opcional, ya que el mockup lo muestra como sección de
/// primer nivel pero el backend no tiene nada nuevo para esto: es puro
/// reordenamiento de datos que ya existen).
class PantallaVehiculosGlobal extends ConsumerStatefulWidget {
  const PantallaVehiculosGlobal({super.key});

  @override
  ConsumerState<PantallaVehiculosGlobal> createState() => _PantallaVehiculosGlobalState();
}

class _PantallaVehiculosGlobalState extends ConsumerState<PantallaVehiculosGlobal> {
  String _patente = '';

  Future<void> _eliminar(Vehiculo vehiculo) async {
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
      ref.invalidate(vehiculosGlobalProvider);
      if (_patente.isNotEmpty) ref.invalidate(vehiculoPorPatenteProvider(_patente));
    } catch (error) {
      if (!mounted) return;
      Notificador.error(context, mensajeDeError(error));
    }
  }

  Widget _tarjeta(Vehiculo vehiculo) {
    return TarjetaVehiculo(
      vehiculo: vehiculo,
      alTocar: () => context.push(
        rutaServicios(vehiculo.clienteId, vehiculo.id!),
        extra: vehiculo,
      ),
      alEditar: () => context.push(
        rutaVehiculoEditar(vehiculo.clienteId, vehiculo.id!),
        extra: vehiculo,
      ),
      alEliminar: () => _eliminar(vehiculo),
    );
  }

  Widget _resultados(BuildContext context) {
    if (_patente.isEmpty) {
      final vehiculos = ref.watch(vehiculosGlobalProvider);
      return VistaAsync<List<Vehiculo>>(
        valor: vehiculos,
        alReintentar: () => ref.invalidate(vehiculosGlobalProvider),
        cargando: ListView.builder(
          itemCount: 4,
          itemBuilder: (_, _) => const EsqueletoFilaLista(),
        ),
        enDatos: (lista) {
          if (lista.isEmpty) {
            return const VistaVacia(
              icono: Icons.directions_car_outlined,
              titulo: 'Todavia no hay vehículos registrados',
            );
          }
          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: context.espaciado.md),
            itemCount: lista.length,
            separatorBuilder: (_, _) => SizedBox(height: context.espaciado.separacionLista),
            itemBuilder: (_, indice) => _tarjeta(lista[indice]),
          );
        },
      );
    }

    final resultado = ref.watch(vehiculoPorPatenteProvider(_patente));
    return resultado.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => const VistaVacia(
        icono: Icons.search_off,
        titulo: 'No se encontró ningún vehículo con esa patente',
        textoApoyo: 'Revisá que esté completa y bien escrita.',
      ),
      data: (vehiculo) => Padding(
        padding: EdgeInsets.symmetric(horizontal: context.espaciado.md),
        child: _tarjeta(vehiculo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vehículos')),
      body: ContenedorContenido(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.espaciado.md,
                context.espaciado.sm,
                context.espaciado.md,
                context.espaciado.xs,
              ),
              child: BarraBusqueda(
                sugerencia: 'Buscar por patente',
                onBuscar: (valor) => setState(() => _patente = valor.trim().toUpperCase()),
              ),
            ),
            SizedBox(height: context.espaciado.xs),
            Expanded(child: _resultados(context)),
          ],
        ),
      ),
    );
  }
}
