import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';

/// Botón de ícono con área táctil garantizada de 48×48, sin importar el
/// tamaño del ícono que se le pase.
class BotonIcono extends StatelessWidget {
  final IconData icono;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;

  const BotonIcono({
    super.key,
    required this.icono,
    required this.onPressed,
    this.tooltip,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icono),
      onPressed: onPressed,
      tooltip: tooltip,
      color: color,
      constraints: const BoxConstraints(
        minWidth: Espaciado.objetivoTactil,
        minHeight: Espaciado.objetivoTactil,
      ),
    );
  }
}
