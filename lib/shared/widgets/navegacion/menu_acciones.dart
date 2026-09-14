import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';

class AccionMenu<T> {
  final T valor;
  final String etiqueta;
  final IconData? icono;

  const AccionMenu({required this.valor, required this.etiqueta, this.icono});
}

/// El `PopupMenuButton` de editar/eliminar, parametrizado — reemplaza las
/// 3 copias de las pantallas de listado.
class MenuAcciones<T> extends StatelessWidget {
  final List<AccionMenu<T>> acciones;
  final ValueChanged<T> onSeleccionar;

  const MenuAcciones({super.key, required this.acciones, required this.onSeleccionar});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      onSelected: onSeleccionar,
      itemBuilder: (contextoMenu) => [
        for (final accion in acciones)
          PopupMenuItem<T>(
            value: accion.valor,
            child: accion.icono == null
                ? Text(accion.etiqueta)
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(accion.icono),
                      SizedBox(width: contextoMenu.espaciado.xs),
                      Text(accion.etiqueta),
                    ],
                  ),
          ),
      ],
    );
  }
}
