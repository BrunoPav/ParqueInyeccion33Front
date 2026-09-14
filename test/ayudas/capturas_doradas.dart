import 'dart:io';
import 'dart:typed_data' show ByteData;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader, rootBundle;
import 'package:flutter_test/flutter_test.dart';

/// Carga los `.ttf` reales de `assets/fuentes/` y la fuente de Material
/// Icons del SDK para que los goldens muestren texto e íconos de verdad:
/// `flutter test` no carga ninguna fuente por defecto y sin esto cada
/// glifo sale como un bloque sólido.
Future<void> cargarFuentesDePrueba() async {
  await _cargarFuente('Inter', [
    'Inter-Regular.ttf',
    'Inter-Medium.ttf',
    'Inter-SemiBold.ttf',
    'Inter-Bold.ttf',
  ]);
  await _cargarFuente('JetBrains Mono', [
    'JetBrainsMono-Regular.ttf',
    'JetBrainsMono-Medium.ttf',
    'JetBrainsMono-Bold.ttf',
  ]);
  await _cargarIconosMaterial();
}

Future<void> _cargarFuente(String familia, List<String> archivos) async {
  final loader = FontLoader(familia);
  for (final archivo in archivos) {
    loader.addFont(rootBundle.load('assets/fuentes/$archivo'));
  }
  await loader.load();
}

/// El `.otf` de Material Icons vive en `cache/artifacts/material_fonts/`
/// del SDK de Flutter, no en los assets del proyecto, y el binario que
/// ejecuta `flutter test` (`flutter_tester`, no `dart`) cuelga de un nivel
/// de carpetas distinto según la plataforma. En vez de asumir una
/// profundidad fija, se sube desde el ejecutable buscando esa carpeta —
/// portable entre Windows/Linux/macOS y entre local/CI. Si no se
/// encuentra, se ignora en silencio: los íconos quedan como bloques, pero
/// el resto del golden sigue siendo válido.
Future<void> _cargarIconosMaterial() async {
  try {
    File? fuente;
    var directorio = File(Platform.resolvedExecutable).parent;

    for (var subidas = 0; subidas < 8 && fuente == null; subidas++) {
      for (final relativo in [
        'cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
        'artifacts/material_fonts/MaterialIcons-Regular.otf',
      ]) {
        final candidato = File(
          '${directorio.path}${Platform.pathSeparator}${relativo.replaceAll('/', Platform.pathSeparator)}',
        );
        if (candidato.existsSync()) {
          fuente = candidato;
          break;
        }
      }

      final superior = directorio.parent;
      if (superior.path == directorio.path) break;
      directorio = superior;
    }

    if (fuente == null) return;

    final loader = FontLoader('MaterialIcons')
      ..addFont(fuente.readAsBytes().then(ByteData.sublistView));
    await loader.load();
  } catch (_) {
    return;
  }
}

/// Monta [widget] bajo [tema] y compara contra `test/shared/goldens/nombre.png`.
/// Pensado para un componente aislado, no una pantalla completa.
Future<void> montarYCapturar(
  WidgetTester tester,
  String nombre,
  Widget widget,
  ThemeData tema, {
  Size tamano = const Size(320, 120),
  bool asentar = true,
}) async {
  tester.view.physicalSize = tamano;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: tema,
      home: Scaffold(
        body: Center(
          child: Padding(padding: const EdgeInsets.all(16), child: widget),
        ),
      ),
    ),
  );
  await tester.pump();
  // Los spinners indeterminados (CircularProgressIndicator) giran sin
  // parar: asentar el frame los deja en un ángulo no reproducible entre
  // corridas. Ese estado se captura en el primer frame, sin avanzar el reloj.
  if (asentar) {
    await tester.pump(const Duration(milliseconds: 300));
  }

  await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/$nombre.png'));
}

/// Registra un `testWidgets` por cada entrada de [estados] (reposo,
/// deshabilitado, etc.) y, si se pasa [conPresionado], uno más que simula
/// el dedo abajo sin soltar para capturar el estado presionado.
void goldenDeEstados(
  String nombre, {
  required ThemeData tema,
  required Map<String, Widget Function()> estados,
  Widget Function()? conPresionado,
  Size tamano = const Size(320, 120),
  Set<String> sinAsentar = const {},
}) {
  setUpAll(cargarFuentesDePrueba);

  for (final entrada in estados.entries) {
    testWidgets('$nombre ${entrada.key}', (tester) async {
      await montarYCapturar(
        tester,
        '${nombre}_${entrada.key}',
        entrada.value(),
        tema,
        tamano: tamano,
        asentar: !sinAsentar.contains(entrada.key),
      );
    });
  }

  if (conPresionado != null) {
    testWidgets('$nombre presionado', (tester) async {
      final widget = conPresionado();
      tester.view.physicalSize = tamano;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          theme: tema,
          home: Scaffold(
            body: Center(
              child: Padding(padding: const EdgeInsets.all(16), child: widget),
            ),
          ),
        ),
      );
      await tester.pump();

      final centro = tester.getCenter(find.byWidget(widget));
      final gesto = await tester.startGesture(centro);
      await tester.pump(const Duration(milliseconds: 100));

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/${nombre}_presionado.png'),
      );

      await gesto.up();
      await tester.pump();
    });
  }
}
