import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/routing/rutas.dart';
import '../proveedores/sesion_proveedores.dart';

class AccionSesion extends ConsumerWidget {
  const AccionSesion({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sesion = ref.watch(sesionProvider);

    // Sin sesión no muestra nada: el acceso al login vive en la navegación
    // principal, al lado de Ajustes. Repetirlo acá sería ruido.
    if (sesion == null) return const SizedBox.shrink();

    return IconButton(
      tooltip: '${sesion.nombreUsuario} — ir a Ajustes',
      onPressed: () => context.go(Rutas.ajustes),
      icon: CircleAvatar(
        radius: Dimensiones.avatarChico / 2,
        backgroundColor: context.colores.primaryContainer,
        foregroundColor: context.colores.onPrimaryContainer,
        child: Text(
          sesion.nombreUsuario.characters.first.toUpperCase(),
          style: context.textos.labelSmall,
        ),
      ),
    );
  }
}
