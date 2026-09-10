import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Se sobrescribe en `main.dart` con `overrideWithValue` tras
/// `await SharedPreferences.getInstance()`, para que el resto de la app lo
/// lea de forma sincrónica.
final preferenciasProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'preferenciasProvider debe sobrescribirse en main.dart antes de correr la app',
  );
});
