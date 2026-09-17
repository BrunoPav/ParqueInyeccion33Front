import 'package:flutter/material.dart';

import '../../../core/design_system/tokens/tipografia.dart';
import '../../../core/utilidades/formatos.dart';

class CampoFecha extends StatelessWidget {
  final String etiqueta;
  final DateTime valor;
  final ValueChanged<DateTime> onCambiar;
  final DateTime? primeraFecha;
  final DateTime? ultimaFecha;

  const CampoFecha({
    super.key,
    required this.etiqueta,
    required this.valor,
    required this.onCambiar,
    this.primeraFecha,
    this.ultimaFecha,
  });

  Future<void> _elegir(BuildContext context) async {
    final ahora = DateTime.now();
    final elegida = await showDatePicker(
      context: context,
      initialDate: valor,
      firstDate: primeraFecha ?? DateTime(ahora.year - 20),
      lastDate: ultimaFecha ?? ahora,
    );
    if (elegida != null) onCambiar(elegida);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _elegir(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: etiqueta,
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(Formatos.fecha(valor), style: const TextStyle().conCifrasTabulares),
      ),
    );
  }
}
