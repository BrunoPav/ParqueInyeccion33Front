import 'package:flutter/material.dart';

import '../widgets/botones/boton_peligro.dart';

/// Título, cuerpo y etiquetas configurables, con variante destructiva —
/// reemplaza las 2 copias del `AlertDialog` de borrado. La variante
/// destructiva corrige un detalle de las copias actuales: un "Eliminar"
/// debe leerse como destructivo, no con el color primario.
Future<bool> dialogoConfirmacion(
  BuildContext context, {
  required String titulo,
  required String cuerpo,
  String etiquetaConfirmar = 'Confirmar',
  String etiquetaCancelar = 'Cancelar',
  bool destructivo = false,
}) async {
  final confirmado = await showDialog<bool>(
    context: context,
    builder: (dialogo) => AlertDialog(
      title: Text(titulo),
      content: Text(cuerpo),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogo).pop(false),
          child: Text(etiquetaCancelar),
        ),
        destructivo
            ? BotonPeligro(
                etiqueta: etiquetaConfirmar,
                expandido: false,
                onPressed: () => Navigator.of(dialogo).pop(true),
              )
            : FilledButton(
                onPressed: () => Navigator.of(dialogo).pop(true),
                child: Text(etiquetaConfirmar),
              ),
      ],
    ),
  );
  return confirmado ?? false;
}
