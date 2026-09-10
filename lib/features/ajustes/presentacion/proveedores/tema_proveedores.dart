import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_system.dart';
import '../../datos/preferencias.dart';

const _claveModoTema = 'modo_tema';
const _claveIdTema = 'id_tema';

class ModoTemaNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final guardado = ref.read(preferenciasProvider).getString(_claveModoTema);
    return ThemeMode.values.firstWhere(
      (modo) => modo.name == guardado,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> establecer(ThemeMode modo) async {
    state = modo;
    await ref.read(preferenciasProvider).setString(_claveModoTema, modo.name);
  }
}

final modoTemaProvider = NotifierProvider<ModoTemaNotifier, ThemeMode>(
  ModoTemaNotifier.new,
);

class TemaSeleccionadoNotifier extends Notifier<IdTema> {
  @override
  IdTema build() {
    final guardado = ref.read(preferenciasProvider).getString(_claveIdTema);
    return IdTema.values.firstWhere(
      (id) => id.name == guardado,
      orElse: () => IdTema.precision,
    );
  }

  Future<void> establecer(IdTema id) async {
    state = id;
    await ref.read(preferenciasProvider).setString(_claveIdTema, id.name);
  }
}

final temaSeleccionadoProvider = NotifierProvider<TemaSeleccionadoNotifier, IdTema>(
  TemaSeleccionadoNotifier.new,
);
