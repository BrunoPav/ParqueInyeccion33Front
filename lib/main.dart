import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/aplicacion.dart';
import 'features/ajustes/datos/preferencias.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferencias = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [preferenciasProvider.overrideWithValue(preferencias)],
      child: const AplicacionTaller(),
    ),
  );
}
