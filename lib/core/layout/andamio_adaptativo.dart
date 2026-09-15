import 'package:flutter/material.dart';

import '../routing/destinos.dart';
import 'contexto_layout.dart';
import 'puntos_corte.dart';

/// Rail extendido con etiquetas solo en expandido: así lo muestran los
/// mockups web (screen4/screen6); en medio va solo con íconos.
class AndamioAdaptativo extends StatelessWidget {
  final String rutaActual;
  final ValueChanged<String> alSeleccionarDestino;
  final Widget child;

  const AndamioAdaptativo({
    super.key,
    required this.rutaActual,
    required this.alSeleccionarDestino,
    required this.child,
  });

  int get _indiceSeleccionado {
    final indice = destinosNavegacion.indexWhere(
      (destino) => rutaActual.startsWith(destino.ruta),
    );
    return indice == -1 ? 0 : indice;
  }

  @override
  Widget build(BuildContext context) {
    final puntoCorte = context.puntoCorte;

    if (puntoCorte == PuntoCorte.compacto) {
      return Scaffold(
        body: SafeArea(child: child),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _indiceSeleccionado,
          onDestinationSelected: (indice) =>
              alSeleccionarDestino(destinosNavegacion[indice].ruta),
          destinations: [
            for (final destino in destinosNavegacion)
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
              selectedIndex: _indiceSeleccionado,
              onDestinationSelected: (indice) =>
                  alSeleccionarDestino(destinosNavegacion[indice].ruta),
              labelType: puntoCorte == PuntoCorte.expandido
                  ? null
                  : NavigationRailLabelType.none,
              destinations: [
                for (final destino in destinosNavegacion)
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
