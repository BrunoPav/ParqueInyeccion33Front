import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/retroalimentacion/vista_async.dart';

/// Resuelve una entidad a partir de su id para las rutas que la reciben
/// como parámetro (edición): si se navegó con el objeto ya en mano
/// (`extra`, camino interno) lo usa directo; si se entró por URL — deep
/// link o refresh, sin `extra` — lo pide por id y cubre carga y error
/// con `VistaAsync`.
class ResolverPorId<T> extends ConsumerWidget {
  final T? extra;
  final AsyncValue<T> Function(WidgetRef ref) leer;
  final void Function(WidgetRef ref) reintentar;
  final Widget Function(T valor) constructor;

  const ResolverPorId({
    super.key,
    required this.extra,
    required this.leer,
    required this.reintentar,
    required this.constructor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final valorExtra = extra;
    if (valorExtra != null) return constructor(valorExtra);

    return VistaAsync<T>(
      valor: leer(ref),
      alReintentar: () => reintentar(ref),
      enDatos: constructor,
    );
  }
}
