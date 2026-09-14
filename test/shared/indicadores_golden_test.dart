import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taller_mecanico_frontend/core/design_system/design_system.dart';
import 'package:taller_mecanico_frontend/shared/widgets/indicadores/avatar.dart';
import 'package:taller_mecanico_frontend/shared/widgets/indicadores/chip_estado.dart';
import 'package:taller_mecanico_frontend/shared/widgets/indicadores/etiqueta_metadato.dart';
import 'package:taller_mecanico_frontend/shared/widgets/indicadores/fila_inspeccion.dart';
import 'package:taller_mecanico_frontend/shared/widgets/indicadores/insignia_patente.dart';

import '../ayudas/capturas_doradas.dart';

void main() {
  for (final brillo in Brightness.values) {
    final paleta = brillo == Brightness.dark
        ? const PaletaPrecisionOscura()
        : const PaletaPrecisionClara();
    final tema = temaPrecision(paleta, brillo);
    final sufijo = brillo == Brightness.dark ? 'oscuro' : 'claro';

    group('ChipEstado ($sufijo)', () {
      goldenDeEstados(
        'chip_estado_$sufijo',
        tema: tema,
        tamano: const Size(200, 60),
        estados: {
          'exito': () =>
              const ChipEstado(estado: EstadoTaller.exito, etiqueta: 'Listo'),
          'en_curso': () =>
              const ChipEstado(estado: EstadoTaller.enCurso, etiqueta: 'En curso'),
          'pendiente': () =>
              const ChipEstado(estado: EstadoTaller.pendiente, etiqueta: 'Pendiente'),
          'critico': () =>
              const ChipEstado(estado: EstadoTaller.critico, etiqueta: 'Crítico'),
          'archivado': () =>
              const ChipEstado(estado: EstadoTaller.archivado, etiqueta: 'Archivado'),
        },
      );
    });

    group('InsigniaPatente ($sufijo)', () {
      goldenDeEstados(
        'insignia_patente_$sufijo',
        tema: tema,
        tamano: const Size(160, 60),
        estados: {
          'reposo': () => const InsigniaPatente(patente: 'af320ok'),
        },
      );
    });

    group('EtiquetaMetadato ($sufijo)', () {
      goldenDeEstados(
        'etiqueta_metadato_$sufijo',
        tema: tema,
        tamano: const Size(220, 60),
        estados: {
          'texto': () =>
              const EtiquetaMetadato(icono: Icons.person, texto: 'Matias Ramos'),
          'numerico': () => const EtiquetaMetadato(
                icono: Icons.speed,
                texto: '124.500 km',
                esNumerico: true,
              ),
        },
      );
    });

    group('Avatar ($sufijo)', () {
      goldenDeEstados(
        'avatar_$sufijo',
        tema: tema,
        tamano: const Size(120, 120),
        estados: {
          'inicial': () => const Avatar(inicial: 'A'),
          'icono': () => const Avatar(icono: Icons.directions_car),
        },
      );
    });

    group('FilaInspeccion ($sufijo)', () {
      goldenDeEstados(
        'fila_inspeccion_$sufijo',
        tema: tema,
        tamano: const Size(360, 72),
        estados: {
          'sin_marcar': () => const FilaInspeccion(
                titulo: 'Pastillas de freno',
                estado: EstadoInspeccion.sinMarcar,
              ),
          'aprobado': () => const FilaInspeccion(
                titulo: 'Pastillas de freno',
                estado: EstadoInspeccion.aprobado,
              ),
          'atencion': () => const FilaInspeccion(
                titulo: 'Pastillas de freno',
                estado: EstadoInspeccion.atencion,
              ),
          'falla': () => const FilaInspeccion(
                titulo: 'Pastillas de freno',
                estado: EstadoInspeccion.falla,
              ),
        },
      );
    });
  }
}
