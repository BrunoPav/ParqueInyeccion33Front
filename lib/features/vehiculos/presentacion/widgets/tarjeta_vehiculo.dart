import 'package:flutter/material.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/utilidades/formatos.dart';
import '../../../../shared/shared.dart';
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
    final fila = FilaLista(
      filaSuperior: InsigniaPatente(patente: vehiculo.patente),
      titulo: vehiculo.descripcionCorta,
      filaInferior: EtiquetaMetadato(
        icono: Icons.speed_outlined,
        texto: Formatos.kilometraje(vehiculo.kilometraje),
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
      onTap: alTocar,
    );

    if (!seleccionado) return fila;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: RadiosTaller.tarjeta,
        border: Border.all(color: context.colores.primary, width: 2),
      ),
      child: fila,
    );
  }
}
