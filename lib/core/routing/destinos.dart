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
    ruta: Rutas.vehiculosGlobal,
    icono: Icons.directions_car_outlined,
    iconoSeleccionado: Icons.directions_car,
    etiqueta: 'Vehículos',
  ),
  DestinoNavegacion(
    ruta: Rutas.ajustes,
    icono: Icons.settings_outlined,
    iconoSeleccionado: Icons.settings,
    etiqueta: 'Ajustes',
  ),
];

const _destinoLogin = DestinoNavegacion(
  ruta: Rutas.login,
  icono: Icons.login,
  iconoSeleccionado: Icons.login,
  etiqueta: 'Iniciar sesión',
);

/// Sin sesión se suma el acceso al login. Con sesión no hace falta: Ajustes ya
/// muestra quién entró y permite cerrar sesión, y un destino que lleve al mismo
/// lugar sería ruido.
List<DestinoNavegacion> destinosPara({required bool haySesion}) {
  return haySesion ? destinosNavegacion : [...destinosNavegacion, _destinoLogin];
}
