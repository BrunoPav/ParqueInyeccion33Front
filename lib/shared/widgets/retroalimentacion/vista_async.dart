import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'vista_error.dart';

/// Los tres estados de un `AsyncValue` siempre cubiertos: cargando, error
/// (con reintentar) y datos. Sin valores literales — todo lo visual lo
/// resuelven `VistaError` y el `child` de `enDatos`.
class VistaAsync<T> extends StatelessWidget {
  final AsyncValue<T> valor;
  final Widget Function(T datos) enDatos;
  final VoidCallback alReintentar;
  final Widget? cargando;

  const VistaAsync({
    super.key,
    required this.valor,
    required this.enDatos,
    required this.alReintentar,
    this.cargando,
  });

  @override
  Widget build(BuildContext context) {
    return valor.when(
      loading: () => cargando ?? const Center(child: CircularProgressIndicator()),
      error: (error, _) => VistaError(mensaje: error.toString(), alReintentar: alReintentar),
      data: enDatos,
    );
  }
}
