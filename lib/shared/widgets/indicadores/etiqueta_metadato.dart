import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';

class EtiquetaMetadato extends StatelessWidget {
  final IconData icono;
  final String texto;
  final bool esNumerico;

  const EtiquetaMetadato({
    super.key,
    required this.icono,
    required this.texto,
    this.esNumerico = false,
  });

  @override
  Widget build(BuildContext context) {
    final estilo = context.textos.bodySmall;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icono, size: Dimensiones.iconoPequeno, color: context.colores.onSurfaceVariant),
        SizedBox(width: context.espaciado.xxs),
        Flexible(
          child: Text(
            texto,
            style: esNumerico ? estilo?.conCifrasTabulares : estilo,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
