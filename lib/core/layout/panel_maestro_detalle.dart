import 'package:flutter/material.dart';

import '../design_system/tokens/tokens.dart';

/// En compacto cada pantalla apila (push normal); este widget no se usa ahí.
class PanelMaestroDetalle extends StatelessWidget {
  final Widget maestro;
  final Widget detalle;

  const PanelMaestroDetalle({super.key, required this.maestro, required this.detalle});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(width: Dimensiones.anchoMaestro, child: maestro),
        const VerticalDivider(width: 1),
        Expanded(child: detalle),
      ],
    );
  }
}
