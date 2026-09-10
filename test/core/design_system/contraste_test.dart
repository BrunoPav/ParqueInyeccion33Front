import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:taller_mecanico_frontend/core/design_system/tokens/paleta.dart';

double _linealizar(double canal) {
  return canal <= 0.03928
      ? canal / 12.92
      : math.pow((canal + 0.055) / 1.055, 2.4).toDouble();
}

double _luminancia(Color color) {
  final r = _linealizar(color.r);
  final g = _linealizar(color.g);
  final b = _linealizar(color.b);
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

/// Ratio de contraste WCAG entre dos colores opacos.
double contraste(Color a, Color b) {
  final la = _luminancia(a) + 0.05;
  final lb = _luminancia(b) + 0.05;
  return la > lb ? la / lb : lb / la;
}

const _textoNormal = 4.5;
const _componenteGrafico = 3.0;

void main() {
  for (final (nombre, paleta) in [
    ('clara', const PaletaPrecisionClara()),
    ('oscura', const PaletaPrecisionOscura()),
  ]) {
    group('Contraste WCAG AA - paleta $nombre', () {
      test('texto sobre botones y contenedores', () {
        expect(contraste(paleta.onPrimario, paleta.primario), greaterThanOrEqualTo(_textoNormal));
        expect(
          contraste(paleta.onPrimarioContenedor, paleta.primarioContenedor),
          greaterThanOrEqualTo(_textoNormal),
        );
        expect(contraste(paleta.onSecundario, paleta.secundario), greaterThanOrEqualTo(_textoNormal));
        expect(
          contraste(paleta.onSecundarioContenedor, paleta.secundarioContenedor),
          greaterThanOrEqualTo(_textoNormal),
        );
        expect(contraste(paleta.onTerciario, paleta.terciario), greaterThanOrEqualTo(_textoNormal));
        expect(
          contraste(paleta.onTerciarioContenedor, paleta.terciarioContenedor),
          greaterThanOrEqualTo(_textoNormal),
        );
        expect(contraste(paleta.onError, paleta.error), greaterThanOrEqualTo(_textoNormal));
        expect(
          contraste(paleta.onErrorContenedor, paleta.errorContenedor),
          greaterThanOrEqualTo(_textoNormal),
        );
      });

      test('texto sobre fondo y superficies', () {
        expect(contraste(paleta.onFondo, paleta.fondo), greaterThanOrEqualTo(_textoNormal));
        expect(
          contraste(paleta.onSuperficie, paleta.superficie),
          greaterThanOrEqualTo(_textoNormal),
        );
        expect(
          contraste(paleta.onSuperficie, paleta.superficieContenedorMasBaja),
          greaterThanOrEqualTo(_textoNormal),
        );
        expect(
          contraste(paleta.onSuperficie, paleta.superficieContenedorMasAlta),
          greaterThanOrEqualTo(_textoNormal),
        );
        expect(
          contraste(paleta.onSuperficieVariante, paleta.superficie),
          greaterThanOrEqualTo(_textoNormal),
        );
        expect(
          contraste(paleta.onSuperficieInversa, paleta.superficieInversa),
          greaterThanOrEqualTo(_textoNormal),
        );
      });

      test('texto sobre chips de estado semantico', () {
        for (final tono in [
          paleta.estadoExito,
          paleta.estadoInfo,
          paleta.estadoPendiente,
          paleta.estadoCritico,
          paleta.estadoArchivado,
        ]) {
          expect(contraste(tono.texto, tono.fondo), greaterThanOrEqualTo(_textoNormal));
        }
      });

      test('borde de contorno visible contra la superficie', () {
        expect(
          contraste(paleta.contorno, paleta.superficie),
          greaterThanOrEqualTo(_componenteGrafico),
        );
      });
    });
  }
}
