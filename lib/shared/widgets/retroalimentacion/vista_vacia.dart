import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../botones/boton_primario.dart';

/// La anatomía del mockup para un estado vacío: ícono, título, texto de
/// apoyo opcional y una acción primaria opcional ("Crear el primero").
class VistaVacia extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String? textoApoyo;
  final String? etiquetaAccion;
  final VoidCallback? onAccion;

  const VistaVacia({
    super.key,
    required this.icono,
    required this.titulo,
    this.textoApoyo,
    this.etiquetaAccion,
    this.onAccion,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.espaciado.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: Dimensiones.iconoGrande, color: context.colores.outline),
            SizedBox(height: context.espaciado.md),
            Text(titulo, style: context.textos.titleMedium, textAlign: TextAlign.center),
            if (textoApoyo != null) ...[
              SizedBox(height: context.espaciado.xxs),
              Text(
                textoApoyo!,
                textAlign: TextAlign.center,
                style: context.textos.bodyMedium?.copyWith(color: context.colores.onSurfaceVariant),
              ),
            ],
            if (etiquetaAccion != null && onAccion != null) ...[
              SizedBox(height: context.espaciado.lg),
              BotonPrimario(etiqueta: etiquetaAccion!, onPressed: onAccion, expandido: false),
            ],
          ],
        ),
      ),
    );
  }
}
