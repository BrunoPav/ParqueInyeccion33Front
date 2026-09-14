import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';

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
