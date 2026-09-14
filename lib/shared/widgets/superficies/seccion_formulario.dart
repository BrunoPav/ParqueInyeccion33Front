import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';

/// Agrupa campos de formulario con un encabezado opcional y el espaciado
/// vertical del token entre cada uno — elimina los `SizedBox(height: 16)`
/// sueltos entre `TextFormField`.
class SeccionFormulario extends StatelessWidget {
  final String? titulo;
  final List<Widget> campos;

  const SeccionFormulario({super.key, this.titulo, required this.campos});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (titulo != null) ...[
          Text(titulo!, style: context.textos.titleMedium),
          SizedBox(height: context.espaciado.sm),
        ],
        for (var indice = 0; indice < campos.length; indice++) ...[
          campos[indice],
          if (indice != campos.length - 1) SizedBox(height: context.espaciado.md),
        ],
      ],
    );
  }
}
