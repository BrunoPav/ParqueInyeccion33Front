import 'package:flutter/material.dart';

import '../../../../shared/shared.dart';
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
    return FilaLista(
      leading: Avatar(inicial: cliente.nombre.isEmpty ? null : cliente.nombre[0]),
      titulo: cliente.nombre,
      descripcion: cliente.contacto?.isNotEmpty == true ? cliente.contacto : 'Sin contacto',
      filaInferior: cliente.activo
          ? null
          : const EtiquetaMetadato(icono: Icons.person_off_outlined, texto: 'Inactivo'),
      trailing: MenuAcciones<String>(
        onSeleccionar: (opcion) {
          if (opcion == 'editar') alEditar();
          if (opcion == 'estado') alCambiarEstado();
        },
        acciones: [
          const AccionMenu(valor: 'editar', etiqueta: 'Editar', icono: Icons.edit_outlined),
          AccionMenu(
            valor: 'estado',
            etiqueta: cliente.activo ? 'Desactivar' : 'Activar',
            icono: cliente.activo ? Icons.person_off_outlined : Icons.person_outline,
          ),
        ],
      ),
      onTap: alTocar,
    );
  }
}
