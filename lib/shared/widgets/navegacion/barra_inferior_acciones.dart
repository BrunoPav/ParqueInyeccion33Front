import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';

/// `SafeArea` solo abajo: el borde y la sombra ya delimitan la barra por
/// arriba, y el inset inferior es el que hace falta respetar en Android
/// con gestos.
class BarraInferiorAcciones extends StatelessWidget {
  final Widget child;

  const BarraInferiorAcciones({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final nivel = context.elevacion.n3;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colores.surfaceContainerLowest,
        border: Border(top: BorderSide(color: nivel.colorBorde, width: nivel.anchoBorde)),
        boxShadow: nivel.sombra,
      ),
      child: SafeArea(
        top: false,
        child: Padding(padding: EdgeInsets.all(context.espaciado.md), child: child),
      ),
    );
  }
}
