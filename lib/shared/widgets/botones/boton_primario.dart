import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';

/// La "Primary Action" del design-system: altura 52, ancho completo por
/// defecto. `cargando` intercambia el ícono por un spinner y deshabilita
/// `onPressed`, sin que el llamador tenga que manejar ese estado a mano.
class BotonPrimario extends StatelessWidget {
  final String etiqueta;
  final String? etiquetaCargando;
  final VoidCallback? onPressed;
  final IconData? icono;
  final bool cargando;
  final bool expandido;

  const BotonPrimario({
    super.key,
    required this.etiqueta,
    required this.onPressed,
    this.etiquetaCargando,
    this.icono,
    this.cargando = false,
    this.expandido = true,
  });

  @override
  Widget build(BuildContext context) {
    final texto = cargando ? (etiquetaCargando ?? etiqueta) : etiqueta;
    final Widget boton;

    if (icono == null && !cargando) {
      boton = FilledButton(
        onPressed: cargando ? null : onPressed,
        child: Text(texto),
      );
    } else {
      boton = FilledButton.icon(
        onPressed: cargando ? null : onPressed,
        icon: cargando
            ? SizedBox(
                width: Dimensiones.spinnerBoton,
                height: Dimensiones.spinnerBoton,
                child: CircularProgressIndicator(
                  strokeWidth: Dimensiones.anchoTrazoSpinner,
                  color: context.colores.onPrimary,
                ),
              )
            : Icon(icono),
        label: Text(texto),
      );
    }

    if (!expandido) return boton;
    return SizedBox(width: double.infinity, child: boton);
  }
}
