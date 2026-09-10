import 'package:flutter/material.dart';

import '../tokens/elevacion.dart';
import '../tokens/paleta.dart';

/// Un nivel de elevación resuelto: [EstiloElevacion] (ancho de borde y
/// sombra, de F1) más el color de borde que le corresponde a la paleta
/// activa.
class NivelElevacion {
  final Color colorBorde;
  final double anchoBorde;
  final List<BoxShadow> sombra;

  const NivelElevacion({
    required this.colorBorde,
    required this.anchoBorde,
    required this.sombra,
  });

  static NivelElevacion lerp(NivelElevacion a, NivelElevacion b, double t) {
    return NivelElevacion(
      colorBorde: Color.lerp(a.colorBorde, b.colorBorde, t)!,
      anchoBorde: a.anchoBorde + (b.anchoBorde - a.anchoBorde) * t,
      sombra: t < 0.5 ? a.sombra : b.sombra,
    );
  }
}

/// Los 3 niveles de "Elevación y Profundidad" ya resueltos contra una
/// paleta y un brillo. En modo oscuro la sombra difusa deja de aportar
/// (se pierde contra un fondo ya oscuro) y la separación pasa a
/// comunicarse solo con el borde y la capa tonal de superficie.
class ElevacionTema extends ThemeExtension<ElevacionTema> {
  final NivelElevacion n1;
  final NivelElevacion n2;
  final NivelElevacion n3;

  const ElevacionTema({required this.n1, required this.n2, required this.n3});

  factory ElevacionTema.desdePaleta(Paleta paleta, Brightness brillo) {
    final sinSombra = brillo == Brightness.dark;

    return ElevacionTema(
      n1: NivelElevacion(
        colorBorde: paleta.contornoVariante,
        anchoBorde: Elevacion.n1.anchoBorde,
        sombra: sinSombra ? const [] : Elevacion.n1.sombra,
      ),
      n2: NivelElevacion(
        colorBorde: paleta.contorno,
        anchoBorde: Elevacion.n2.anchoBorde,
        sombra: sinSombra ? const [] : Elevacion.n2.sombra,
      ),
      n3: NivelElevacion(
        colorBorde: paleta.contornoVariante,
        anchoBorde: Elevacion.n3.anchoBorde,
        sombra: sinSombra ? const [] : Elevacion.n3.sombra,
      ),
    );
  }

  @override
  ElevacionTema copyWith({NivelElevacion? n1, NivelElevacion? n2, NivelElevacion? n3}) {
    return ElevacionTema(
      n1: n1 ?? this.n1,
      n2: n2 ?? this.n2,
      n3: n3 ?? this.n3,
    );
  }

  @override
  ElevacionTema lerp(ThemeExtension<ElevacionTema>? other, double t) {
    if (other is! ElevacionTema) return this;
    return ElevacionTema(
      n1: NivelElevacion.lerp(n1, other.n1, t),
      n2: NivelElevacion.lerp(n2, other.n2, t),
      n3: NivelElevacion.lerp(n3, other.n3, t),
    );
  }
}
