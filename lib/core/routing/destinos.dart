import 'package:flutter/material.dart';

import 'rutas.dart';

class DestinoNavegacion {
  final String ruta;
  final IconData icono;
  final IconData iconoSeleccionado;
  final String etiqueta;

  const DestinoNavegacion({
    required this.ruta,
    required this.icono,
    required this.iconoSeleccionado,
    required this.etiqueta,
  });
}

/// Los destinos de navegación principal. Agregar una sección nueva a la app
/// es agregar una entrada acá.
const destinosNavegacion = [
  DestinoNavegacion(
    ruta: Rutas.clientes,
    icono: Icons.people_outline,
    iconoSeleccionado: Icons.people,
    etiqueta: 'Clientes',
  ),
  DestinoNavegacion(
    ruta: Rutas.ajustes,
    icono: Icons.settings_outlined,
    iconoSeleccionado: Icons.settings,
    etiqueta: 'Ajustes',
  ),
];
