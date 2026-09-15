import 'package:flutter/widgets.dart';

import '../design_system/extensiones/contexto_tema.dart';
import 'puntos_corte.dart';

/// Acceso corto al breakpoint activo. Igual que [ContextoTema], la API que
/// usan las pantallas: nunca `MediaQuery.sizeOf(context).width` comparado a
/// mano contra un literal.
extension ContextoLayout on BuildContext {
  PuntoCorte get puntoCorte => PuntoCorte.desdeAncho(MediaQuery.sizeOf(this).width);

  bool get esCompacto => puntoCorte == PuntoCorte.compacto;

  bool get esMedio => puntoCorte == PuntoCorte.medio;

  bool get esExpandido => puntoCorte == PuntoCorte.expandido;

  double get bordePantalla =>
      esCompacto ? espaciado.bordePantallaMovil : espaciado.bordePantallaTablet;
}
