import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/layout/contexto_layout.dart';
import '../../../core/layout/puntos_corte.dart';

/// Reparte los hijos en columnas en vez de usar `GridView` con
/// `childAspectRatio` fijo, para que una tarjeta con más contenido que otra
/// no desborde: cada columna es un [Column] normal, alto por contenido.
class GrillaAdaptativa extends StatelessWidget {
  final List<Widget> children;

  const GrillaAdaptativa({super.key, required this.children});

  int _columnas(PuntoCorte puntoCorte) => switch (puntoCorte) {
    PuntoCorte.compacto => 1,
    PuntoCorte.medio => 2,
    PuntoCorte.expandido => 3,
  };

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    final columnas = _columnas(context.puntoCorte);
    final espacio = context.espaciado.sm;

    if (columnas == 1) {
      return Column(
        children: [
          for (final hijo in children) Padding(padding: EdgeInsets.only(bottom: espacio), child: hijo),
        ],
      );
    }

    final porColumna = List.generate(columnas, (_) => <Widget>[]);
    for (var i = 0; i < children.length; i++) {
      porColumna[i % columnas].add(children[i]);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < columnas; i++) ...[
          if (i > 0) SizedBox(width: espacio),
          Expanded(
            child: Column(
              children: [
                for (final hijo in porColumna[i])
                  Padding(padding: EdgeInsets.only(bottom: espacio), child: hijo),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
