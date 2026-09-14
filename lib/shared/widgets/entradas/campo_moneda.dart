import 'package:flutter/material.dart';

import '../../../core/design_system/tokens/tipografia.dart';
import '../../../core/utilidades/validadores.dart';

/// Acepta coma o punto como separador decimal.
class CampoMoneda extends StatelessWidget {
  final TextEditingController? controller;
  final String etiqueta;
  final bool habilitado;
  final bool autofocus;

  const CampoMoneda({
    super.key,
    this.controller,
    this.etiqueta = 'Precio',
    this.habilitado = true,
    this.autofocus = false,
  });

  /// Convierte el texto ingresado a `double`, aceptando coma o punto como
  /// separador decimal. Lanza si el validador no corrió antes.
  static double parsear(String texto) => double.parse(texto.trim().replaceAll(',', '.'));

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: habilitado,
      autofocus: autofocus,
      decoration: InputDecoration(labelText: etiqueta, prefixText: '\$ '),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: Theme.of(context).textTheme.bodyLarge?.conCifrasTabulares,
      validator: (valor) => Validadores.decimalPositivo(valor, etiqueta: etiqueta),
    );
  }
}
