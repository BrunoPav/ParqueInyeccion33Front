import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/rutas.dart';
import 'vista_vacia.dart';

class PantallaNoEncontrada extends StatelessWidget {
  const PantallaNoEncontrada({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: VistaVacia(
          icono: Icons.signpost_outlined,
          titulo: 'No encontramos esta página',
          textoApoyo: 'La dirección no existe o el enlace está roto.',
          etiquetaAccion: 'Ir a clientes',
          onAccion: () => context.go(Rutas.clientes),
        ),
      ),
    );
  }
}
