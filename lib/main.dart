import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pantallas/pantalla_clientes.dart';

void main() {
  runApp(const ProviderScope(child: AplicacionTaller()));
}

class AplicacionTaller extends StatelessWidget {
  const AplicacionTaller({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taller Mecanico',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
      ),
      home: const PantallaClientes(),
    );
  }
}
