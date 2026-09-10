import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taller_mecanico_frontend/core/design_system/design_system.dart';
import 'package:taller_mecanico_frontend/features/ajustes/datos/preferencias.dart';
import 'package:taller_mecanico_frontend/features/ajustes/presentacion/proveedores/tema_proveedores.dart';

void main() {
  test('alternar modoTemaProvider cambia el ThemeMode expuesto', () async {
    SharedPreferences.setMockInitialValues({});
    final preferencias = await SharedPreferences.getInstance();
    final contenedor = ProviderContainer(
      overrides: [preferenciasProvider.overrideWithValue(preferencias)],
    );
    addTearDown(contenedor.dispose);

    expect(contenedor.read(modoTemaProvider), ThemeMode.system);

    await contenedor.read(modoTemaProvider.notifier).establecer(ThemeMode.dark);

    expect(contenedor.read(modoTemaProvider), ThemeMode.dark);
  });

  test('la preferencia de modo persiste entre instancias del contenedor', () async {
    SharedPreferences.setMockInitialValues({});
    final preferencias = await SharedPreferences.getInstance();

    final primerContenedor = ProviderContainer(
      overrides: [preferenciasProvider.overrideWithValue(preferencias)],
    );
    await primerContenedor
        .read(modoTemaProvider.notifier)
        .establecer(ThemeMode.light);
    primerContenedor.dispose();

    final segundoContenedor = ProviderContainer(
      overrides: [preferenciasProvider.overrideWithValue(preferencias)],
    );
    addTearDown(segundoContenedor.dispose);

    expect(segundoContenedor.read(modoTemaProvider), ThemeMode.light);
  });

  test('la preferencia de tema seleccionado persiste entre instancias', () async {
    SharedPreferences.setMockInitialValues({});
    final preferencias = await SharedPreferences.getInstance();

    final primerContenedor = ProviderContainer(
      overrides: [preferenciasProvider.overrideWithValue(preferencias)],
    );
    await primerContenedor
        .read(temaSeleccionadoProvider.notifier)
        .establecer(IdTema.precision);
    primerContenedor.dispose();

    final segundoContenedor = ProviderContainer(
      overrides: [preferenciasProvider.overrideWithValue(preferencias)],
    );
    addTearDown(segundoContenedor.dispose);

    expect(segundoContenedor.read(temaSeleccionadoProvider), IdTema.precision);
  });
}
