import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';

/// Badge mono, mayúsculas, radio 4, borde 1px. Reemplaza el `Text` crudo
/// de la patente en la fila de vehículos.
class InsigniaPatente extends StatelessWidget {
  final String patente;

  const InsigniaPatente({super.key, required this.patente});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: PaddingTaller.chip,
      decoration: BoxDecoration(
        border: Border.all(color: context.colores.outline),
        borderRadius: RadiosTaller.chip,
      ),
      child: Text(
        patente.toUpperCase(),
        style: Tipografia.labelMono.copyWith(color: context.colores.onSurface),
      ),
    );
  }
}
