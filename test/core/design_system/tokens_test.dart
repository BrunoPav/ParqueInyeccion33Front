import 'package:flutter_test/flutter_test.dart';
import 'package:taller_mecanico_frontend/core/design_system/tokens/tokens.dart';

void main() {
  test('la escala de espaciado es monotona creciente', () {
    const escala = [
      Espaciado.xxs,
      Espaciado.xs,
      Espaciado.sm,
      Espaciado.md,
      Espaciado.lg,
      Espaciado.xl,
      Espaciado.xxl,
    ];

    for (var i = 1; i < escala.length; i++) {
      expect(escala[i], greaterThan(escala[i - 1]));
    }
  });

  test('objetivoTactilAmplio es mayor que objetivoTactil', () {
    expect(Espaciado.objetivoTactilAmplio, greaterThan(Espaciado.objetivoTactil));
  });

  test('los radios semanticos apuntan a los valores esperados', () {
    expect(RadiosTaller.chip.topLeft.x, Radios.sm);
    expect(RadiosTaller.tarjeta.topLeft.x, Radios.lg);
    expect(RadiosTaller.boton.topLeft.x, Radios.lg);
    expect(RadiosTaller.entrada.topLeft.x, Radios.lg);
    expect(RadiosTaller.contenedor.topLeft.x, Radios.xl);
  });

  test('la escala de radios es monotona creciente', () {
    const escala = [Radios.xs, Radios.sm, Radios.md, Radios.lg, Radios.xl];

    for (var i = 1; i < escala.length; i++) {
      expect(escala[i], greaterThan(escala[i - 1]));
    }
  });

  test('objetivoTactilAmplio en Dimensiones cierra con la altura de boton primario', () {
    expect(Dimensiones.botonPrimario, greaterThanOrEqualTo(Espaciado.objetivoTactil));
    expect(Dimensiones.botonSecundario, Espaciado.objetivoTactil);
  });
}
