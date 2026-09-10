import 'package:flutter/material.dart';

import '../tokens/paleta.dart';
import 'tema_precision.dart';

/// Un tema disponible en la app. Sumar uno nuevo es agregar un valor acá y
/// una entrada en [catalogoTemas] — nada más.
enum IdTema { precision }

typedef ConstructorTema = ThemeData Function(Brightness brillo);

/// Registro de todos los temas de la app. No es `const` porque sus valores
/// son closures con una rama por brillo, que Dart no admite como expresión
/// constante; sigue siendo la única fuente de verdad de qué temas existen.
final Map<IdTema, ConstructorTema> catalogoTemas = {
  IdTema.precision: (brillo) {
    final Paleta paleta = brillo == Brightness.dark
        ? const PaletaPrecisionOscura()
        : const PaletaPrecisionClara();
    return temaPrecision(paleta, brillo);
  },
};
