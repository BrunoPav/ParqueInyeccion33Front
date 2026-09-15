import 'package:flutter/material.dart';

import '../../../core/design_system/tokens/tokens.dart';
import '../../../core/layout/contexto_layout.dart';

class ContenedorFormulario extends StatelessWidget {
  final Widget child;

  const ContenedorFormulario({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (context.esCompacto) return SafeArea(child: child);

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Dimensiones.anchoMaximoFormulario),
          child: child,
        ),
      ),
    );
  }
}
