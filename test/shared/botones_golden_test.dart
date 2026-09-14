import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taller_mecanico_frontend/core/design_system/design_system.dart';
import 'package:taller_mecanico_frontend/shared/widgets/botones/boton_icono.dart';
import 'package:taller_mecanico_frontend/shared/widgets/botones/boton_peligro.dart';
import 'package:taller_mecanico_frontend/shared/widgets/botones/boton_primario.dart';
import 'package:taller_mecanico_frontend/shared/widgets/botones/boton_secundario.dart';

import '../ayudas/capturas_doradas.dart';

void main() {
  for (final brillo in Brightness.values) {
    final paleta = brillo == Brightness.dark
        ? const PaletaPrecisionOscura()
        : const PaletaPrecisionClara();
    final tema = temaPrecision(paleta, brillo);
    final sufijo = brillo == Brightness.dark ? 'oscuro' : 'claro';

    group('BotonPrimario ($sufijo)', () {
      goldenDeEstados(
        'boton_primario_$sufijo',
        tema: tema,
        estados: {
          'reposo': () =>
              BotonPrimario(etiqueta: 'Guardar', icono: Icons.save, onPressed: () {}),
          'deshabilitado': () =>
              const BotonPrimario(etiqueta: 'Guardar', icono: Icons.save, onPressed: null),
          'cargando': () => BotonPrimario(
                etiqueta: 'Guardar',
                icono: Icons.save,
                cargando: true,
                onPressed: () {},
              ),
        },
        conPresionado: () =>
            BotonPrimario(etiqueta: 'Guardar', icono: Icons.save, onPressed: () {}),
        sinAsentar: const {'cargando'},
      );
    });

    group('BotonSecundario ($sufijo)', () {
      goldenDeEstados(
        'boton_secundario_$sufijo',
        tema: tema,
        estados: {
          'reposo': () => BotonSecundario(etiqueta: 'Añadir repuesto', onPressed: () {}),
          'deshabilitado': () =>
              const BotonSecundario(etiqueta: 'Añadir repuesto', onPressed: null),
        },
        conPresionado: () => BotonSecundario(etiqueta: 'Añadir repuesto', onPressed: () {}),
      );
    });

    group('BotonPeligro ($sufijo)', () {
      goldenDeEstados(
        'boton_peligro_$sufijo',
        tema: tema,
        estados: {
          'reposo': () => BotonPeligro(etiqueta: 'Eliminar', onPressed: () {}),
          'deshabilitado': () => const BotonPeligro(etiqueta: 'Eliminar', onPressed: null),
        },
        conPresionado: () => BotonPeligro(etiqueta: 'Eliminar', onPressed: () {}),
      );
    });

    group('BotonIcono ($sufijo)', () {
      goldenDeEstados(
        'boton_icono_$sufijo',
        tema: tema,
        estados: {
          'reposo': () => BotonIcono(icono: Icons.settings, onPressed: () {}),
          'deshabilitado': () => const BotonIcono(icono: Icons.settings, onPressed: null),
        },
        conPresionado: () => BotonIcono(icono: Icons.settings, onPressed: () {}),
      );
    });
  }
}
