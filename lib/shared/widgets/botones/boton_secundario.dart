import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';

/// La "Secondary Action" del design-system: altura 48, fondo tenue, borde
/// 1px. Para acciones como "Añadir Repuesto" o "Pausar" — no compite con
/// [BotonPrimario] por atención.
class BotonSecundario extends StatelessWidget {
  final String etiqueta;
  final VoidCallback? onPressed;
  final IconData? icono;
  final bool expandido;

  const BotonSecundario({
    super.key,
    required this.etiqueta,
    required this.onPressed,
    this.icono,
    this.expandido = true,
  });

  @override
  Widget build(BuildContext context) {
    final estilo = OutlinedButton.styleFrom(
      backgroundColor: context.colores.surfaceContainerHigh,
      foregroundColor: context.colores.onSurface,
      side: BorderSide(color: context.colores.outline),
      minimumSize: const Size.fromHeight(Dimensiones.botonSecundario),
      shape: const RoundedRectangleBorder(borderRadius: RadiosTaller.boton),
      textStyle: Tipografia.labelLg,
    );

    final boton = icono == null
        ? OutlinedButton(onPressed: onPressed, style: estilo, child: Text(etiqueta))
        : OutlinedButton.icon(
            onPressed: onPressed,
            style: estilo,
            icon: Icon(icono),
            label: Text(etiqueta),
          );

    if (!expandido) return boton;
    return SizedBox(width: double.infinity, child: boton);
  }
}
