import 'package:flutter/material.dart';

import 'colores_estado.dart';
import 'elevacion_tema.dart';
import 'espaciado_tema.dart';

/// Acceso corto a los colores y tokens del tema activo. Esta extension es
/// la API que usan las pantallas y los widgets de `/shared`: nunca
/// `Theme.of(context).extension<...>()` a mano, y nunca un [Color] o un
/// tamaño instanciado por su cuenta.
extension ContextoTema on BuildContext {
  ColorScheme get colores => Theme.of(this).colorScheme;

  TextTheme get textos => Theme.of(this).textTheme;

  ColoresEstado get estados => Theme.of(this).extension<ColoresEstado>()!;

  EspaciadoTema get espaciado => Theme.of(this).extension<EspaciadoTema>()!;

  ElevacionTema get elevacion => Theme.of(this).extension<ElevacionTema>()!;
}
