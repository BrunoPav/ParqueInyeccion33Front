import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';

/// Toma el color de [ColoresEstado.critico], la misma terna que usan los
/// chips de estado crítico.
class BotonPeligro extends StatelessWidget {
  final String etiqueta;
  final VoidCallback? onPressed;
  final IconData? icono;
  final bool expandido;

  const BotonPeligro({
    super.key,
    required this.etiqueta,
    required this.onPressed,
    this.icono,
    this.expandido = true,
  });

  @override
  Widget build(BuildContext context) {
    final critico = context.estados.critico;
    final estilo = OutlinedButton.styleFrom(
      backgroundColor: critico.fondo,
      foregroundColor: critico.texto,
      side: BorderSide(color: critico.borde),
      minimumSize: const Size.fromHeight(Dimensiones.botonSecundario),
      shape: const RoundedRectangleBorder(borderRadius: RadiosTaller.boton),
      textStyle: Tipografia.labelLg,
    );

    final boton = icono == null
        ? OutlinedButton(onPressed: onPressed, style: estilo, child: Text(etiqueta))
        : OutlinedButton.icon(
            onPressed: onPressed,
            style: estilo,
            icon: Icon(icono),
            label: Text(etiqueta),
          );

    if (!expandido) return boton;
    return SizedBox(width: double.infinity, child: boton);
  }
}
