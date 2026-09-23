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

    if (sesion == null) {
      return TextButton.icon(
        onPressed: () => context.go(Rutas.login),
        icon: const Icon(Icons.login, size: 18),
        label: const Text('Iniciar sesión'),
      );
    }

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
