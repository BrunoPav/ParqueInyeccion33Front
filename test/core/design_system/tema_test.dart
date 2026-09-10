import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taller_mecanico_frontend/core/design_system/design_system.dart';

void main() {
  final temaClaro = temaPrecision(const PaletaPrecisionClara(), Brightness.light);
  final temaOscuro = temaPrecision(const PaletaPrecisionOscura(), Brightness.dark);

  test('el tema claro trae las 3 ThemeExtension', () {
    expect(temaClaro.extension<ColoresEstado>(), isNotNull);
    expect(temaClaro.extension<EspaciadoTema>(), isNotNull);
    expect(temaClaro.extension<ElevacionTema>(), isNotNull);
  });

  test('el tema oscuro trae las 3 ThemeExtension', () {
    expect(temaOscuro.extension<ColoresEstado>(), isNotNull);
    expect(temaOscuro.extension<EspaciadoTema>(), isNotNull);
    expect(temaOscuro.extension<ElevacionTema>(), isNotNull);
  });

  test('lerp al 50% entre claro y oscuro no lanza ni pierde ninguna extension', () {
    final intermedio = ThemeData.lerp(temaClaro, temaOscuro, 0.5);

    expect(intermedio.extension<ColoresEstado>(), isNotNull);
    expect(intermedio.extension<EspaciadoTema>(), isNotNull);
    expect(intermedio.extension<ElevacionTema>(), isNotNull);
  });

  test('el catalogo de temas resuelve "precision" en ambos brillos', () {
    final constructor = catalogoTemas[IdTema.precision]!;

    expect(constructor(Brightness.light).brightness, Brightness.light);
    expect(constructor(Brightness.dark).brightness, Brightness.dark);
  });
}
