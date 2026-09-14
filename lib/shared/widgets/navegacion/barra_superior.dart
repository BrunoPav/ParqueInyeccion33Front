import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';

/// `AppBar` con subtítulo como parámetro, en vez del `PreferredSize` +
/// `Padding` a mano que hoy se repite en dos pantallas.
class BarraSuperior extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final String? subtitulo;
  final List<Widget>? acciones;
  final Widget? leading;

  const BarraSuperior({
    super.key,
    required this.titulo,
    this.subtitulo,
    this.acciones,
    this.leading,
  });

  static const double _alturaSubtitulo = 24;

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (subtitulo == null ? 0 : _alturaSubtitulo),
      );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      title: Text(titulo),
      actions: acciones,
      bottom: subtitulo == null
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(_alturaSubtitulo),
              child: Padding(
                padding: EdgeInsets.only(bottom: context.espaciado.xs),
                child: Text(subtitulo!, style: context.textos.bodySmall),
              ),
            ),
    );
  }
}
