import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/sesion/presentacion/proveedores/sesion_proveedores.dart';
import '../routing/destinos.dart';
import 'contexto_layout.dart';
import 'puntos_corte.dart';

/// Rail extendido con etiquetas solo en expandido: así lo muestran los
/// mockups web (screen4/screen6); en medio va solo con íconos.
class AndamioAdaptativo extends ConsumerWidget {
  final String rutaActual;
  final ValueChanged<String> alSeleccionarDestino;
  final Widget child;

  const AndamioAdaptativo({
    super.key,
    required this.rutaActual,
    required this.alSeleccionarDestino,
    required this.child,
  });

  int _indiceSeleccionado(List<DestinoNavegacion> destinos) {
    final indice = destinos.indexWhere(
      (destino) => rutaActual.startsWith(destino.ruta),
    );
    return indice == -1 ? 0 : indice;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puntoCorte = context.puntoCorte;
    final destinos = destinosPara(haySesion: ref.watch(haySesionProvider));
    final seleccionado = _indiceSeleccionado(destinos);

    if (puntoCorte == PuntoCorte.compacto) {
      return Scaffold(
        body: SafeArea(child: child),
        bottomNavigationBar: NavigationBar(
          selectedIndex: seleccionado,
          onDestinationSelected: (indice) =>
              alSeleccionarDestino(destinos[indice].ruta),
          destinations: [
            for (final destino in destinos)
              NavigationDestination(
                icon: Icon(destino.icono),
                selectedIcon: Icon(destino.iconoSeleccionado),
                label: destino.etiqueta,
              ),
          ],
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NavigationRail(
              extended: puntoCorte == PuntoCorte.expandido,
              minExtendedWidth: 220,
              selectedIndex: seleccionado,
              onDestinationSelected: (indice) =>
                  alSeleccionarDestino(destinos[indice].ruta),
              labelType: puntoCorte == PuntoCorte.expandido
                  ? null
                  : NavigationRailLabelType.none,
              destinations: [
                for (final destino in destinos)
                  NavigationRailDestination(
                    icon: Icon(destino.icono),
                    selectedIcon: Icon(destino.iconoSeleccionado),
                    label: Text(destino.etiqueta),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
