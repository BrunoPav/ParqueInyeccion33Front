import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/design_system/design_system.dart';
import '../features/ajustes/presentacion/proveedores/tema_proveedores.dart';
import '../features/clientes/presentacion/pantallas/pantalla_clientes.dart';

class AplicacionTaller extends ConsumerWidget {
  const AplicacionTaller({super.key});

  Brightness _brilloResuelto(BuildContext context, ThemeMode modo) {
    return switch (modo) {
      ThemeMode.light => Brightness.light,
      ThemeMode.dark => Brightness.dark,
      ThemeMode.system => MediaQuery.platformBrightnessOf(context),
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modo = ref.watch(modoTemaProvider);
    final idTema = ref.watch(temaSeleccionadoProvider);
    final constructor = catalogoTemas[idTema]!;
    final brilloResuelto = _brilloResuelto(context, modo);
    final colorFondoResuelto = constructor(brilloResuelto).colorScheme.surface;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (brilloResuelto == Brightness.dark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark)
          .copyWith(
        systemNavigationBarColor: colorFondoResuelto,
        systemNavigationBarIconBrightness:
            brilloResuelto == Brightness.dark ? Brightness.light : Brightness.dark,
      ),
      child: MaterialApp(
        title: 'Taller Mecanico',
        debugShowCheckedModeBanner: false,
        theme: constructor(Brightness.light),
        darkTheme: constructor(Brightness.dark),
        themeMode: modo,
        home: const PantallaClientes(),
      ),
    );
  }
}
