import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taller_mecanico_frontend/core/design_system/design_system.dart';
import 'package:taller_mecanico_frontend/shared/widgets/entradas/campo_texto.dart';
import 'package:taller_mecanico_frontend/shared/widgets/indicadores/insignia_patente.dart';
import 'package:taller_mecanico_frontend/shared/widgets/navegacion/barra_inferior_acciones.dart';
import 'package:taller_mecanico_frontend/shared/widgets/superficies/fila_lista.dart';
import 'package:taller_mecanico_frontend/shared/widgets/superficies/seccion_formulario.dart';
import 'package:taller_mecanico_frontend/shared/widgets/superficies/tarjeta_taller.dart';

import '../ayudas/capturas_doradas.dart';

void main() {
  for (final brillo in Brightness.values) {
    final paleta = brillo == Brightness.dark
        ? const PaletaPrecisionOscura()
        : const PaletaPrecisionClara();
    final tema = temaPrecision(paleta, brillo);
    final sufijo = brillo == Brightness.dark ? 'oscuro' : 'claro';

    group('TarjetaTaller ($sufijo)', () {
      goldenDeEstados(
        'tarjeta_taller_$sufijo',
        tema: tema,
        estados: {
          'n1': () => const TarjetaTaller(child: Text('Nivel 1')),
          'n2': () => const TarjetaTaller(
                nivel: NivelTarjeta.n2,
                child: Text('Nivel 2'),
              ),
          'n3': () => const TarjetaTaller(
                nivel: NivelTarjeta.n3,
                child: Text('Nivel 3'),
              ),
        },
      );
    });

    group('FilaLista ($sufijo)', () {
      goldenDeEstados(
        'fila_lista_$sufijo',
        tema: tema,
        tamano: const Size(360, 220),
        estados: {
          'completa': () => FilaLista(
                filaSuperior: const InsigniaPatente(patente: 'AF320OK'),
                titulo: 'Toyota Hilux (2020)',
                descripcion: 'Pick-up cabina doble, motor 1GD-FTV turbo diesel',
                filaInferior: const Text('124.500 km'),
                onTap: () {},
              ),
        },
      );
    });

    group('SeccionFormulario ($sufijo)', () {
      goldenDeEstados(
        'seccion_formulario_$sufijo',
        tema: tema,
        tamano: const Size(360, 220),
        estados: {
          'con_titulo': () => const SeccionFormulario(
                titulo: 'Datos del vehículo',
                campos: [
                  CampoTexto(etiqueta: 'Marca'),
                  CampoTexto(etiqueta: 'Modelo'),
                ],
              ),
        },
      );
    });

    group('BarraInferiorAcciones ($sufijo)', () {
      goldenDeEstados(
        'barra_inferior_acciones_$sufijo',
        tema: tema,
        tamano: const Size(360, 100),
        estados: {
          'con_boton': () => BarraInferiorAcciones(
                child: FilledButton(
                  onPressed: () {},
                  child: const Text('Guardar'),
                ),
              ),
        },
      );
    });
  }
}
