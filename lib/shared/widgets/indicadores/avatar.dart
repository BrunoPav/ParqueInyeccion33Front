import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';

class Avatar extends StatelessWidget {
  final String? inicial;
  final IconData? icono;
  final double tamano;

  const Avatar({
    super.key,
    this.inicial,
    this.icono,
    this.tamano = Dimensiones.avatarMediano,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: tamano / 2,
      backgroundColor: context.colores.surfaceContainerHigh,
      foregroundColor: context.colores.onSurfaceVariant,
      child: icono != null
          ? Icon(icono, size: tamano * 0.5)
          : Text(
              (inicial == null || inicial!.isEmpty) ? '?' : inicial!.toUpperCase(),
              style: context.textos.titleMedium?.copyWith(color: context.colores.onSurfaceVariant),
            ),
    );
  }
}
