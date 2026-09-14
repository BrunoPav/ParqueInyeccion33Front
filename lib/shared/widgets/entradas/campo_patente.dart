import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design_system/tokens/tipografia.dart';
import '../../../core/utilidades/validadores.dart';

class _FormateadorMayusculas extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue valorAnterior,
    TextEditingValue valorNuevo,
  ) {
    return valorNuevo.copyWith(text: valorNuevo.text.toUpperCase());
  }
}

/// Mayúsculas forzadas en la entrada (no solo al mostrarla), tipografía
/// mono y largo máximo — la regla de desambiguación `0`/`O`, `1`/`I` del
/// design-system aplicada desde que el mecánico empieza a tipear.
class CampoPatente extends StatelessWidget {
  final TextEditingController? controller;
  final String etiqueta;
  final int longitudMaxima;
  final bool habilitado;
  final bool autofocus;

  const CampoPatente({
    super.key,
    this.controller,
    this.etiqueta = 'Patente',
    this.longitudMaxima = 10,
    this.habilitado = true,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: habilitado,
      autofocus: autofocus,
      decoration: InputDecoration(labelText: etiqueta),
      textCapitalization: TextCapitalization.characters,
      style: Tipografia.labelMono.copyWith(color: Theme.of(context).colorScheme.onSurface),
      inputFormatters: [
        _FormateadorMayusculas(),
        LengthLimitingTextInputFormatter(longitudMaxima),
      ],
      validator: Validadores.combinar([
        (valor) => Validadores.obligatorio(valor, etiqueta: etiqueta),
        (valor) => Validadores.largoMaximo(valor, longitudMaxima),
      ]),
    );
  }
}
