import 'package:flutter/widgets.dart';

import '../design_system/tokens/tokens.dart';
import 'contexto_layout.dart';

class ContenedorContenido extends StatelessWidget {
  final Widget child;

  const ContenedorContenido({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Dimensiones.anchoMaximoContenido),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.bordePantalla),
          child: child,
        ),
      ),
    );
  }
}
