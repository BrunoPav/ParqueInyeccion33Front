import 'package:flutter/material.dart';

import '../../../core/design_system/tokens/tipografia.dart';
import '../../../core/utilidades/validadores.dart';

/// Teclado numérico forzado y cifras tabulares, como exige el
/// design-system para odómetro, SKU y cantidades. Reemplaza a
/// `_validarEntero`, que hoy vive dentro de cada pantalla.
class CampoNumerico extends StatelessWidget {
  final TextEditingController? controller;
  final String etiqueta;
  final int minimo;
  final int maximo;
  final bool habilitado;
  final bool autofocus;

  const CampoNumerico({
    super.key,
    this.controller,
    required this.etiqueta,
    required this.minimo,
    required this.maximo,
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
      keyboardType: TextInputType.number,
      style: Theme.of(context).textTheme.bodyLarge?.conCifrasTabulares,
      validator: (valor) => Validadores.rangoEntero(
        valor,
        minimo: minimo,
        maximo: maximo,
        etiqueta: etiqueta,
      ),
    );
  }
}
