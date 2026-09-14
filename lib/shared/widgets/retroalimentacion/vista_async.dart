import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'vista_error.dart';

/// `AsyncValue.when` obliga a cubrir los tres estados: no hay forma de
/// olvidarse de `loading` o `error` como pasaría con un `if`/`else` a mano.
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
