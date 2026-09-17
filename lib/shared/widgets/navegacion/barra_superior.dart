import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';

class BarraSuperior extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final String? subtitulo;
  final Widget? subtituloWidget;
  final List<Widget>? acciones;
  final Widget? leading;

  const BarraSuperior({
    super.key,
    required this.titulo,
    this.subtitulo,
    this.subtituloWidget,
    this.acciones,
    this.leading,
  }) : assert(
         subtitulo == null || subtituloWidget == null,
         'BarraSuperior recibe subtitulo o subtituloWidget, no los dos.',
       );

  static const double _alturaSubtitulo = 24;

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (subtitulo == null && subtituloWidget == null ? 0 : _alturaSubtitulo),
      );

  @override
  Widget build(BuildContext context) {
    final contenidoSubtitulo = subtituloWidget ??
        (subtitulo == null ? null : Text(subtitulo!, style: context.textos.bodySmall));

    return AppBar(
      leading: leading,
      title: Text(titulo),
      actions: acciones,
      bottom: contenidoSubtitulo == null
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(_alturaSubtitulo),
              child: Padding(
                padding: EdgeInsets.only(bottom: context.espaciado.xs),
                child: DefaultTextStyle(
                  style: context.textos.bodySmall ?? const TextStyle(),
                  child: contenidoSubtitulo,
                ),
              ),
            ),
    );
  }
}
