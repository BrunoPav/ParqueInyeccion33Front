import 'package:flutter/material.dart';

import '../../../../core/utilidades/formatos.dart';
import '../../dominio/servicio.dart';

class ResumenServicios extends StatelessWidget {
  final List<Servicio> servicios;

  const ResumenServicios({super.key, required this.servicios});

  @override
  Widget build(BuildContext context) {
    final total = calcularTotal(servicios);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              '${servicios.length} servicio${servicios.length == 1 ? '' : 's'}',
              style: Theme.of(context).textTheme.titleSmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'Total: ${Formatos.moneda(total)}',
              style: Theme.of(context).textTheme.titleSmall,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
