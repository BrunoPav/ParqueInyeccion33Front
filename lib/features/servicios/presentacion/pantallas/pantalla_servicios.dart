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
    final confirmado = await dialogoConfirmacion(
      context,
      titulo: 'Eliminar servicio',
      cuerpo: 'Se va a eliminar este servicio del historial. Esta accion no se puede deshacer.',
      etiquetaConfirmar: 'Eliminar',
      destructivo: true,
    );
    if (!confirmado) return;

    try {
      await ref.read(repositorioServiciosProvider).eliminar(servicio.id!);
      ref.invalidate(serviciosPorVehiculoProvider(vehiculo.id!));
    } catch (error) {
      if (!context.mounted) return;
      Notificador.error(context, error.toString());
    }
  }

  void _irAServicios(BuildContext context, Vehiculo otroVehiculo) {
    final ruta = rutaServicios(clienteId, otroVehiculo.id!);
    context.go(ruta, extra: otroVehiculo);
  }

  Widget _historialServicios(BuildContext context, WidgetRef ref, AsyncValue<List<Servicio>> servicios) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            context.espaciado.md,
            context.espaciado.sm,
            context.espaciado.md,
            context.espaciado.xs,
          ),
          child: BotonPrimario(
            etiqueta: 'Nuevo servicio',
            icono: Icons.add,
            onPressed: () => context.push(rutaServicioNuevo(clienteId, vehiculo.id!)),
          ),
        ),
        Expanded(
          child: VistaAsync<List<Servicio>>(
            valor: servicios,
            alReintentar: () => ref.invalidate(serviciosPorVehiculoProvider(vehiculo.id!)),
            cargando: ListView.builder(
              itemCount: 4,
              itemBuilder: (_, _) => const EsqueletoFilaLista(),
            ),
            enDatos: (lista) {
              if (lista.isEmpty) {
                return const VistaVacia(
                  icono: Icons.build_outlined,
                  titulo: 'Este vehículo no tiene servicios registrados',
                  textoApoyo: 'Usá el botón de arriba para registrar el primero.',
                );
              }

              return Column(
                children: [
                  ResumenServicios(servicios: lista),
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: context.espaciado.md),
                      itemCount: lista.length,
                      separatorBuilder: (_, _) =>
                          SizedBox(height: context.espaciado.separacionLista),
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
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicios = ref.watch(serviciosPorVehiculoProvider(vehiculo.id!));

    return Scaffold(
      appBar: BarraSuperior(
        titulo: vehiculo.descripcionCorta,
        subtituloWidget: Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'Historial de '),
              TextSpan(
                text: vehiculo.patente.toUpperCase(),
                style: Tipografia.labelMono,
              ),
            ],
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
    );
  }
}
