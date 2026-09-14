import 'package:flutter/material.dart';

import '../../dominio/cliente.dart';

class TarjetaCliente extends StatelessWidget {
  final Cliente cliente;
  final VoidCallback alTocar;
  final VoidCallback alEditar;
  final VoidCallback alCambiarEstado;

  const TarjetaCliente({
    super.key,
    required this.cliente,
    required this.alTocar,
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
      onTap: alTocar,
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
