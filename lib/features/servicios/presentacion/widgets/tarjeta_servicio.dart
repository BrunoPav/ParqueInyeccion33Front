import 'package:flutter/material.dart';

import '../../../../core/utilidades/formatos.dart';
import '../../../../shared/shared.dart';
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
    return FilaLista(
      leading: const Avatar(icono: Icons.build_outlined),
      titulo: Formatos.fecha(servicio.fecha),
      descripcion: servicio.descripcion,
      // El precio va en la fila inferior, no al lado del menú: un `Row` con
      // ambos ahí se queda sin ancho en el panel de detalle angosto del
      // maestro-detalle (F7.10) — ver F9.13.
      filaInferior: EtiquetaMetadato(
        icono: Icons.attach_money,
        texto: Formatos.moneda(servicio.precio),
        esNumerico: true,
      ),
      trailing: MenuAcciones<String>(
        onSeleccionar: (opcion) {
          if (opcion == 'editar') alEditar();
          if (opcion == 'eliminar') alEliminar();
        },
        acciones: const [
          AccionMenu(valor: 'editar', etiqueta: 'Editar', icono: Icons.edit_outlined),
          AccionMenu(valor: 'eliminar', etiqueta: 'Eliminar', icono: Icons.delete_outline),
        ],
      ),
    );
  }
}
