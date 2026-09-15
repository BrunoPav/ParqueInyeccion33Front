import 'package:flutter/material.dart';

import '../../dominio/vehiculo.dart';

class TarjetaVehiculo extends StatelessWidget {
  final Vehiculo vehiculo;
  final VoidCallback alTocar;
  final VoidCallback alEditar;
  final VoidCallback alEliminar;
  final bool seleccionado;

  const TarjetaVehiculo({
    super.key,
    required this.vehiculo,
    required this.alTocar,
    required this.alEditar,
    required this.alEliminar,
    this.seleccionado = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: seleccionado,
      leading: const CircleAvatar(child: Icon(Icons.directions_car)),
      title: Text(vehiculo.descripcionCorta),
      subtitle: Text('${vehiculo.patente}  -  ${vehiculo.kilometraje} km'),
      onTap: alTocar,
      trailing: PopupMenuButton<String>(
        onSelected: (opcion) {
          if (opcion == 'editar') alEditar();
          if (opcion == 'eliminar') alEliminar();
        },
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'editar', child: Text('Editar')),
          PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
        ],
      ),
    );
  }
}
