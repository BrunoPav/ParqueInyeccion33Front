import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/layout/contenedor_contenido.dart';
import '../proveedores/tema_proveedores.dart';

class PantallaAjustes extends ConsumerWidget {
  const PantallaAjustes({super.key});

  String _etiquetaModo(ThemeMode modo) {
    return switch (modo) {
      ThemeMode.light => 'Claro',
      ThemeMode.dark => 'Oscuro',
      ThemeMode.system => 'Igual al sistema',
    };
  }

  String _etiquetaTema(IdTema id) {
    return switch (id) {
      IdTema.precision => 'Precision Workshop',
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modoActual = ref.watch(modoTemaProvider);
    final idTemaActual = ref.watch(temaSeleccionadoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ContenedorContenido(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: context.espaciado.md, bottom: context.espaciado.xs),
              child: Text('Apariencia', style: context.textos.titleMedium),
            ),
            RadioGroup<ThemeMode>(
              groupValue: modoActual,
              onChanged: (valor) {
                if (valor != null) {
                  ref.read(modoTemaProvider.notifier).establecer(valor);
                }
              },
              child: Column(
                children: [
                  for (final modo in ThemeMode.values)
                    RadioListTile<ThemeMode>(
                      title: Text(_etiquetaModo(modo)),
                      value: modo,
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: EdgeInsets.only(top: context.espaciado.md, bottom: context.espaciado.xs),
              child: Text('Tema', style: context.textos.titleMedium),
            ),
            RadioGroup<IdTema>(
              groupValue: idTemaActual,
              onChanged: (valor) {
                if (valor != null) {
                  ref.read(temaSeleccionadoProvider.notifier).establecer(valor);
                }
              },
              child: Column(
                children: [
                  for (final id in IdTema.values)
                    RadioListTile<IdTema>(
                      secondary: _MuestraTema(id: id, brillo: Theme.of(context).brightness),
                      title: Text(_etiquetaTema(id)),
                      value: id,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// El color primario del tema en el brillo activo, antes de aplicarlo —
/// F9.25.
class _MuestraTema extends StatelessWidget {
  final IdTema id;
  final Brightness brillo;

  const _MuestraTema({required this.id, required this.brillo});

  @override
  Widget build(BuildContext context) {
    final colores = catalogoTemas[id]!(brillo).colorScheme;
    return CircleAvatar(
      radius: Dimensiones.avatarChico / 2,
      backgroundColor: colores.primary,
      foregroundColor: colores.onPrimary,
      child: const Icon(Icons.palette_outlined, size: Dimensiones.iconoPequeno),
    );
  }
}
