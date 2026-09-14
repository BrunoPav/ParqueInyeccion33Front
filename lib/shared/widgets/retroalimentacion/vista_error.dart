import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../botones/boton_secundario.dart';

/// Extraída de `VistaAsync` para poder usarla sola, por ejemplo dentro de
/// un panel de master-detail (`compacto: true` reduce el padding y el
/// tamaño del ícono para ese caso).
class VistaError extends StatelessWidget {
  final String mensaje;
  final VoidCallback alReintentar;
  final bool compacto;

  const VistaError({
    super.key,
    required this.mensaje,
    required this.alReintentar,
    this.compacto = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(compacto ? context.espaciado.md : context.espaciado.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off,
              size: compacto ? Dimensiones.iconoMediano : Dimensiones.iconoGrande,
              color: context.colores.outline,
            ),
            SizedBox(height: context.espaciado.md),
            Text(mensaje, textAlign: TextAlign.center, style: context.textos.bodyLarge),
            SizedBox(height: context.espaciado.md),
            BotonSecundario(
              etiqueta: 'Reintentar',
              icono: Icons.refresh,
              onPressed: alReintentar,
              expandido: false,
            ),
          ],
        ),
      ),
    );
  }
}
