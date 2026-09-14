import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taller_mecanico_frontend/core/design_system/design_system.dart';
import 'package:taller_mecanico_frontend/shared/widgets/entradas/campo_fecha.dart';
import 'package:taller_mecanico_frontend/shared/widgets/entradas/campo_moneda.dart';
import 'package:taller_mecanico_frontend/shared/widgets/entradas/campo_numerico.dart';
import 'package:taller_mecanico_frontend/shared/widgets/entradas/campo_patente.dart';
import 'package:taller_mecanico_frontend/shared/widgets/entradas/campo_texto.dart';

import '../ayudas/capturas_doradas.dart';

Widget _conError(Widget campo) {
  return Form(autovalidateMode: AutovalidateMode.always, child: campo);
}

void main() {
  for (final brillo in Brightness.values) {
    final paleta = brillo == Brightness.dark
        ? const PaletaPrecisionOscura()
        : const PaletaPrecisionClara();
    final tema = temaPrecision(paleta, brillo);
    final sufijo = brillo == Brightness.dark ? 'oscuro' : 'claro';

    group('CampoTexto ($sufijo)', () {
      goldenDeEstados(
        'campo_texto_$sufijo',
        tema: tema,
        estados: {
          'reposo': () => CampoTexto(
                etiqueta: 'Nombre',
                controller: TextEditingController(text: 'Ana Gomez'),
              ),
          'foco': () => const CampoTexto(etiqueta: 'Nombre', autofocus: true),
          'error': () => _conError(
                CampoTexto(
                  etiqueta: 'Nombre',
                  validador: (v) => 'El nombre es obligatorio',
                ),
              ),
          'deshabilitado': () => CampoTexto(
                etiqueta: 'Nombre',
                controller: TextEditingController(text: 'Ana Gomez'),
                habilitado: false,
              ),
        },
      );
    });

    group('CampoNumerico ($sufijo)', () {
      goldenDeEstados(
        'campo_numerico_$sufijo',
        tema: tema,
        estados: {
          'reposo': () => CampoNumerico(
                etiqueta: 'Kilometraje',
                minimo: 0,
                maximo: 999999,
                controller: TextEditingController(text: '124500'),
              ),
          'foco': () => const CampoNumerico(
                etiqueta: 'Kilometraje',
                minimo: 0,
                maximo: 999999,
                autofocus: true,
              ),
          'error': () => _conError(
                const CampoNumerico(etiqueta: 'Kilometraje', minimo: 0, maximo: 999999),
              ),
          'deshabilitado': () => CampoNumerico(
                etiqueta: 'Kilometraje',
                minimo: 0,
                maximo: 999999,
                controller: TextEditingController(text: '124500'),
                habilitado: false,
              ),
        },
      );
    });

    group('CampoMoneda ($sufijo)', () {
      goldenDeEstados(
        'campo_moneda_$sufijo',
        tema: tema,
        estados: {
          'reposo': () => CampoMoneda(controller: TextEditingController(text: '148500.00')),
          'foco': () => const CampoMoneda(autofocus: true),
          'error': () => _conError(const CampoMoneda()),
          'deshabilitado': () => CampoMoneda(
                controller: TextEditingController(text: '148500.00'),
                habilitado: false,
              ),
        },
      );
    });

    group('CampoPatente ($sufijo)', () {
      goldenDeEstados(
        'campo_patente_$sufijo',
        tema: tema,
        estados: {
          'reposo': () => CampoPatente(controller: TextEditingController(text: 'AF320OK')),
          'foco': () => const CampoPatente(autofocus: true),
          'error': () => _conError(const CampoPatente()),
          'deshabilitado': () => CampoPatente(
                controller: TextEditingController(text: 'AF320OK'),
                habilitado: false,
              ),
        },
      );
    });

    group('CampoFecha ($sufijo)', () {
      goldenDeEstados(
        'campo_fecha_$sufijo',
        tema: tema,
        estados: {
          'reposo': () => CampoFecha(etiqueta: 'Fecha', valor: DateTime(2025, 2, 12), onCambiar: (_) {}),
        },
      );
    });
  }
}
