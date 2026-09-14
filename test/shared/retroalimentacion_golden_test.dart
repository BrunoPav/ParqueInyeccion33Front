import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taller_mecanico_frontend/core/design_system/design_system.dart';
import 'package:taller_mecanico_frontend/shared/widgets/retroalimentacion/esqueleto_carga.dart';
import 'package:taller_mecanico_frontend/shared/widgets/retroalimentacion/vista_error.dart';
import 'package:taller_mecanico_frontend/shared/widgets/retroalimentacion/vista_vacia.dart';

import '../ayudas/capturas_doradas.dart';

void main() {
  for (final brillo in Brightness.values) {
    final paleta = brillo == Brightness.dark
        ? const PaletaPrecisionOscura()
        : const PaletaPrecisionClara();
    final tema = temaPrecision(paleta, brillo);
    final sufijo = brillo == Brightness.dark ? 'oscuro' : 'claro';

    group('VistaVacia ($sufijo)', () {
      goldenDeEstados(
        'vista_vacia_$sufijo',
        tema: tema,
        tamano: const Size(320, 320),
        estados: {
          'simple': () => const VistaVacia(
                icono: Icons.people_outline,
                titulo: 'No hay clientes activos',
              ),
          'con_accion': () => VistaVacia(
                icono: Icons.directions_car_outlined,
                titulo: 'Este cliente no tiene vehículos',
                textoApoyo: 'Agregá el primero para empezar a registrar servicios.',
                etiquetaAccion: 'Crear el primero',
                onAccion: () {},
              ),
        },
      );
    });

    group('VistaError ($sufijo)', () {
      goldenDeEstados(
        'vista_error_$sufijo',
        tema: tema,
        tamano: const Size(320, 260),
        estados: {
          'normal': () => VistaError(mensaje: 'No se pudo conectar con el servidor', alReintentar: () {}),
          'compacto': () => VistaError(
                mensaje: 'Sin conexión',
                alReintentar: () {},
                compacto: true,
              ),
        },
      );
    });

    group('EsqueletoCarga ($sufijo)', () {
      goldenDeEstados(
        'esqueleto_carga_$sufijo',
        tema: tema,
        tamano: const Size(320, 220),
        estados: {
          'fila_lista': () => const EsqueletoFilaLista(),
        },
      );
    });
  }
}
