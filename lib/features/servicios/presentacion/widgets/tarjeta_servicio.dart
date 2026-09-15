import 'package:flutter/material.dart';

import '../../../../core/design_system/tokens/tokens.dart';
import '../../../../core/utilidades/formatos.dart';
import '../../dominio/servicio.dart';

class TarjetaServicio extends StatelessWidget {
  final Servicio servicio;
  final VoidCallback alEditar;
  final VoidCallback alEliminar;

  const TarjetaServicio({
    super.key,
    required this.servicio,
    required this.alEditar,
    required this.alEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      leading: const CircleAvatar(child: Icon(Icons.build)),
      title: Text(Formatos.fecha(servicio.fecha)),
      subtitle: Text(servicio.descripcion),
      trailing: SizedBox(
        width: Dimensiones.anchoTrailingConMenu,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                Formatos.moneda(servicio.precio),
                style: Theme.of(context).textTheme.titleSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (opcion) {
                if (opcion == 'editar') alEditar();
                if (opcion == 'eliminar') alEliminar();
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'editar', child: Text('Editar')),
                PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
