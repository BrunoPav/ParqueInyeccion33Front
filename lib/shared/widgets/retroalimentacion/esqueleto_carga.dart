import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';

class EsqueletoCarga extends StatefulWidget {
  final double? ancho;
  final double alto;
  final BorderRadius? radio;

  const EsqueletoCarga({super.key, this.ancho, this.alto = Espaciado.md, this.radio});

  @override
  State<EsqueletoCarga> createState() => _EsqueletoCargaState();
}

class _EsqueletoCargaState extends State<EsqueletoCarga> with SingleTickerProviderStateMixin {
  late final AnimationController _controlador;

  @override
  void initState() {
    super.initState();
    _controlador = AnimationController(vsync: this, duration: Duraciones.lenta * 3)
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = context.colores.surfaceContainerHigh;
    final resaltado = context.colores.surfaceContainerHighest;

    return AnimatedBuilder(
      animation: _controlador,
      builder: (context, _) {
        return Container(
          width: widget.ancho,
          height: widget.alto,
          decoration: BoxDecoration(
            color: Color.lerp(base, resaltado, _controlador.value),
            borderRadius: widget.radio ?? RadiosTaller.chip,
          ),
        );
      },
    );
  }
}

class EsqueletoFilaLista extends StatelessWidget {
  const EsqueletoFilaLista({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingTaller.tarjeta,
      child: Row(
        children: [
          const EsqueletoCarga(
            ancho: Dimensiones.avatarMediano,
            alto: Dimensiones.avatarMediano,
            radio: RadiosTaller.completo,
          ),
          SizedBox(width: context.espaciado.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const EsqueletoCarga(ancho: 160),
                SizedBox(height: context.espaciado.xs),
                const EsqueletoCarga(ancho: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
