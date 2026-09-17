import 'package:flutter/material.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/utilidades/formatos.dart';
import '../../../../shared/shared.dart';
import '../../dominio/servicio.dart';

class ResumenServicios extends StatelessWidget {
  final List<Servicio> servicios;

  const ResumenServicios({super.key, required this.servicios});

  @override
  Widget build(BuildContext context) {
    final total = calcularTotal(servicios);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.espaciado.md,
        context.espaciado.sm,
        context.espaciado.md,
        context.espaciado.sm,
      ),
      child: TarjetaTaller(
        nivel: NivelTarjeta.n2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                '${servicios.length} servicio${servicios.length == 1 ? '' : 's'}',
                style: context.textos.bodyMedium?.copyWith(color: context.colores.onSurfaceVariant),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: context.espaciado.xs),
            Flexible(
              child: Text(
                Formatos.moneda(total),
                style: context.textos.headlineSmall?.conCifrasTabulares,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
