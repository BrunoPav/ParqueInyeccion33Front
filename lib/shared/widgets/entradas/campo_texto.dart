import 'package:flutter/material.dart';

class CampoTexto extends StatelessWidget {
  final TextEditingController? controller;
  final String etiqueta;
  final String? textoAyuda;
  final FormFieldValidator<String>? validador;
  final int maxLineas;
  final TextCapitalization capitalizacion;
  final bool soloLectura;
  final bool habilitado;
  final bool autofocus;
  final VoidCallback? onTap;
  final Widget? sufijo;
  final bool ocultarTexto;

  const CampoTexto({
    super.key,
    this.controller,
    required this.etiqueta,
    this.textoAyuda,
    this.validador,
    this.maxLineas = 1,
    this.capitalizacion = TextCapitalization.none,
    this.soloLectura = false,
    this.habilitado = true,
    this.autofocus = false,
    this.onTap,
    this.sufijo,
    this.ocultarTexto = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: soloLectura,
      enabled: habilitado,
      autofocus: autofocus,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: etiqueta,
        helperText: textoAyuda,
        suffixIcon: sufijo,
        alignLabelWithHint: maxLineas > 1,
      ),
      obscureText: ocultarTexto,
      maxLines: ocultarTexto ? 1 : maxLineas,
      textCapitalization: capitalizacion,
      validator: validador,
    );
  }
}
