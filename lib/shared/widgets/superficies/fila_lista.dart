import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import 'tarjeta_taller.dart';

/// La anatomía de fila del mockup: fila superior (badge + chip), fila media
/// (título + descripción con `line-clamp-2`), fila inferior (metadatos).
/// Toda la tarjeta es un solo target de toque.
class FilaLista extends StatelessWidget {
  final Widget? leading;
  final Widget? filaSuperior;
  final String titulo;
  final String? descripcion;
  final Widget? filaInferior;
  final Widget? trailing;
  final VoidCallback? onTap;

  const FilaLista({
    super.key,
    this.leading,
    this.filaSuperior,
    required this.titulo,
    this.descripcion,
    this.filaInferior,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TarjetaTaller(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leading != null) ...[leading!, SizedBox(width: context.espaciado.sm)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (filaSuperior != null) ...[
                  filaSuperior!,
                  SizedBox(height: context.espaciado.xxs),
                ],
                Text(titulo, style: context.textos.titleMedium),
                if (descripcion != null) ...[
                  SizedBox(height: context.espaciado.xxs),
                  Text(
                    descripcion!,
                    style: context.textos.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (filaInferior != null) ...[
                  SizedBox(height: context.espaciado.xs),
                  filaInferior!,
                ],
              ],
            ),
          ),
          if (trailing != null) ...[SizedBox(width: context.espaciado.sm), trailing!],
        ],
      ),
    );
  }
}
