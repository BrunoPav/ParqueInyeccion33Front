import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';

enum NivelTarjeta { n1, n2, n3 }

class TarjetaTaller extends StatelessWidget {
  final Widget child;
  final NivelTarjeta nivel;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  const TarjetaTaller({
    super.key,
    required this.child,
    this.nivel = NivelTarjeta.n1,
    this.onTap,
    this.padding,
  });

  NivelElevacion _resolver(BuildContext context) {
    return switch (nivel) {
      NivelTarjeta.n1 => context.elevacion.n1,
      NivelTarjeta.n2 => context.elevacion.n2,
      NivelTarjeta.n3 => context.elevacion.n3,
    };
  }

  @override
  Widget build(BuildContext context) {
    final resuelto = _resolver(context);
    final interior = Padding(padding: padding ?? PaddingTaller.tarjeta, child: child);

    // El color de fondo va en el Material, no en esta decoración: así el
    // ripple del InkWell se ve (pintar el fondo acá lo taparía) y
    // clipBehavior lo recorta al radio sin afectar la sombra, que
    // Container pinta por fuera del recorte.
    return Container(
      decoration: BoxDecoration(
        borderRadius: RadiosTaller.tarjeta,
        border: Border.all(color: resuelto.colorBorde, width: resuelto.anchoBorde),
        boxShadow: resuelto.sombra,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: context.colores.surfaceContainerLowest,
        child: onTap == null ? interior : InkWell(onTap: onTap, child: interior),
      ),
    );
  }
}
