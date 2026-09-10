import 'package:flutter/painting.dart';

/// Ancho de borde y sombra de un nivel de elevación. El color del borde no
/// se define acá: depende de la paleta activa (`contorno`/`contornoVariante`)
/// y se resuelve en la `ThemeExtension` de elevación (F2), junto a este
/// estilo.
class EstiloElevacion {
  final double anchoBorde;
  final List<BoxShadow> sombra;

  const EstiloElevacion({required this.anchoBorde, required this.sombra});
}

/// Los 3 niveles de "Elevación y Profundidad" de DESIGN.md: capa tonal +
/// borde 1px crisp, sin sombras difusas de Material por defecto.
abstract final class Elevacion {
  static const EstiloElevacion n1 = EstiloElevacion(
    anchoBorde: 1,
    sombra: [
      BoxShadow(color: Color(0x0D0F172A), offset: Offset(0, 1), blurRadius: 2),
    ],
  );

  static const EstiloElevacion n2 = EstiloElevacion(
    anchoBorde: 1,
    sombra: [
      BoxShadow(
        color: Color(0x140F172A),
        offset: Offset(0, 4),
        blurRadius: 6,
        spreadRadius: -1,
      ),
      BoxShadow(
        color: Color(0x0A0F172A),
        offset: Offset(0, 2),
        blurRadius: 4,
        spreadRadius: -2,
      ),
    ],
  );

  static const EstiloElevacion n3 = EstiloElevacion(
    anchoBorde: 1,
    sombra: [
      BoxShadow(color: Color(0x0F0F172A), offset: Offset(0, -4), blurRadius: 12),
    ],
  );
}
