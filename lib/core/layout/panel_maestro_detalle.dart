import 'package:flutter/material.dart';

import '../design_system/tokens/tokens.dart';

/// En compacto cada pantalla apila (push normal); este widget no se usa ahí.
class PanelMaestroDetalle extends StatelessWidget {
  final Widget maestro;
  final Widget detalle;

  const PanelMaestroDetalle({super.key, required this.maestro, required this.detalle});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Ancho fijo del maestro, pero acotado a un máximo del 45% del
        // espacio disponible: en el extremo angosto del breakpoint medio
        // (ver F9.13), 360px fijos le dejaban al detalle tan poco lugar que
        // una fila con leading + trailing desbordaba.
        final anchoMaestro = Dimensiones.anchoMaestro.clamp(0.0, constraints.maxWidth * 0.45);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(width: anchoMaestro, child: maestro),
            const VerticalDivider(width: 1),
            Expanded(child: detalle),
          ],
        );
      },
    );
  }
}
