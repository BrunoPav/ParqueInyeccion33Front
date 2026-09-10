import 'dart:ui';

/// Terna fondo/borde/texto para un chip o insignia de estado (ej.:
/// "Service al día", "Distribución pendiente").
class TonoEstado {
  final Color fondo;
  final Color borde;
  final Color texto;

  const TonoEstado({required this.fondo, required this.borde, required this.texto});
}

/// Conjunto completo de colores del design-system "Precision Workshop".
///
/// Es la única fuente de valores de color de toda la app: `ThemeData` (en
/// `core/design_system/temas/`) construye el `ColorScheme` y las
/// `ThemeExtension` a partir de una instancia de [Paleta], y ninguna pantalla
/// instancia un [Color] por su cuenta.
abstract class Paleta {
  const Paleta();

  Color get primario;
  Color get onPrimario;
  Color get primarioContenedor;
  Color get onPrimarioContenedor;

  Color get secundario;
  Color get onSecundario;
  Color get secundarioContenedor;
  Color get onSecundarioContenedor;

  Color get terciario;
  Color get onTerciario;
  Color get terciarioContenedor;
  Color get onTerciarioContenedor;

  Color get error;
  Color get onError;
  Color get errorContenedor;
  Color get onErrorContenedor;

  Color get fondo;
  Color get onFondo;
  Color get superficieContenedorMasBaja;
  Color get superficieContenedorBaja;
  Color get superficie;
  Color get superficieContenedor;
  Color get superficieContenedorAlta;
  Color get superficieContenedorMasAlta;
  Color get onSuperficie;
  Color get onSuperficieVariante;

  Color get contorno;
  Color get contornoVariante;

  Color get superficieInversa;
  Color get onSuperficieInversa;
  Color get primarioInverso;

  Color get sombra;
  Color get scrim;
  Color get tinteSuperficie;

  TonoEstado get estadoExito;
  TonoEstado get estadoInfo;
  TonoEstado get estadoPendiente;
  TonoEstado get estadoCritico;
  TonoEstado get estadoArchivado;
}

/// Paleta clara, derivada de `mockups/*.png` (6 capturas de Stitch, Android
/// y web) y de `DESIGN.md` donde el mockup no da evidencia directa —
/// principalmente `error` y `estadoCritico`, que no aparecen en ninguna
/// captura. Los valores leídos de imagen son una aproximación visual, sin
/// muestreo a pixel; se recalibran si algún contraste no cierra al usarlos.
class PaletaPrecisionClara extends Paleta {
  const PaletaPrecisionClara();

  @override
  Color get primario => const Color(0xFF191512);
  @override
  Color get onPrimario => const Color(0xFFFFFFFF);
  @override
  Color get primarioContenedor => const Color(0xFFE8E4E1);
  @override
  Color get onPrimarioContenedor => const Color(0xFF191512);

  @override
  Color get secundario => const Color(0xFFC4501B);
  @override
  Color get onSecundario => const Color(0xFFFFFFFF);
  @override
  Color get secundarioContenedor => const Color(0xFFF7E4DA);
  @override
  Color get onSecundarioContenedor => const Color(0xFF8A3814);

  @override
  Color get terciario => const Color(0xFF6E645D);
  @override
  Color get onTerciario => const Color(0xFFFFFFFF);
  @override
  Color get terciarioContenedor => const Color(0xFFE7E1DD);
  @override
  Color get onTerciarioContenedor => const Color(0xFF3A332F);

  @override
  Color get error => const Color(0xFFBA1A1A);
  @override
  Color get onError => const Color(0xFFFFFFFF);
  @override
  Color get errorContenedor => const Color(0xFFFFDAD6);
  @override
  Color get onErrorContenedor => const Color(0xFF93000A);

  @override
  Color get fondo => const Color(0xFFFBF3F0);
  @override
  Color get onFondo => const Color(0xFF1C1512);
  @override
  Color get superficieContenedorMasBaja => const Color(0xFFFFFFFF);
  @override
  Color get superficieContenedorBaja => const Color(0xFFFEFAF8);
  @override
  Color get superficie => const Color(0xFFFBF3F0);
  @override
  Color get superficieContenedor => const Color(0xFFF7EBE6);
  @override
  Color get superficieContenedorAlta => const Color(0xFFF3E3DC);
  @override
  Color get superficieContenedorMasAlta => const Color(0xFFF0DED8);
  @override
  Color get onSuperficie => const Color(0xFF1C1512);
  @override
  Color get onSuperficieVariante => const Color(0xFF6B5B54);

  @override
  Color get contorno => const Color(0xFF8A7568);
  @override
  Color get contornoVariante => const Color(0xFFF0DED8);

  @override
  Color get superficieInversa => const Color(0xFF322A25);
  @override
  Color get onSuperficieInversa => const Color(0xFFF5EDE9);
  @override
  Color get primarioInverso => const Color(0xFFE8E4E1);

  @override
  Color get sombra => const Color(0xFF000000);
  @override
  Color get scrim => const Color(0xFF000000);
  @override
  Color get tinteSuperficie => primario;

  @override
  TonoEstado get estadoExito => const TonoEstado(
        fondo: Color(0xFFDCFCE7),
        borde: Color(0xFF86EFAC),
        texto: Color(0xFF15803D),
      );
  @override
  TonoEstado get estadoInfo => const TonoEstado(
        fondo: Color(0xFFDBEAFE),
        borde: Color(0xFF93C5FD),
        texto: Color(0xFF1E40AF),
      );
  @override
  TonoEstado get estadoPendiente => const TonoEstado(
        fondo: Color(0xFFFDE4D5),
        borde: Color(0xFFF3A876),
        texto: Color(0xFFA8350D),
      );
  @override
  TonoEstado get estadoCritico => const TonoEstado(
        fondo: Color(0xFFFEE2E2),
        borde: Color(0xFFFCA5A5),
        texto: Color(0xFFB91C1C),
      );
  @override
  TonoEstado get estadoArchivado => const TonoEstado(
        fondo: Color(0xFFEFEAE6),
        borde: Color(0xFFD9D2CC),
        texto: Color(0xFF57504B),
      );
}

/// Paleta oscura. Ningún mockup trae versión oscura: se deriva invirtiendo
/// las capas tonales de [PaletaPrecisionClara] y aclarando el terracota para
/// que siga siendo el acento de mayor saliencia sobre fondo oscuro.
/// Presentada para aprobación antes de cablearse en `ThemeData` (F2).
class PaletaPrecisionOscura extends Paleta {
  const PaletaPrecisionOscura();

  @override
  Color get primario => const Color(0xFFF3E9E4);
  @override
  Color get onPrimario => const Color(0xFF1C1512);
  @override
  Color get primarioContenedor => const Color(0xFF362B23);
  @override
  Color get onPrimarioContenedor => const Color(0xFFF3E9E4);

  @override
  Color get secundario => const Color(0xFFE8794A);
  @override
  Color get onSecundario => const Color(0xFF2B0D00);
  @override
  Color get secundarioContenedor => const Color(0xFF5C2410);
  @override
  Color get onSecundarioContenedor => const Color(0xFFFFD9C2);

  @override
  Color get terciario => const Color(0xFFB4A89F);
  @override
  Color get onTerciario => const Color(0xFF2E2925);
  @override
  Color get terciarioContenedor => const Color(0xFF4A423C);
  @override
  Color get onTerciarioContenedor => const Color(0xFFE7E1DD);

  @override
  Color get error => const Color(0xFFFFB4AB);
  @override
  Color get onError => const Color(0xFF690005);
  @override
  Color get errorContenedor => const Color(0xFF93000A);
  @override
  Color get onErrorContenedor => const Color(0xFFFFDAD6);

  @override
  Color get fondo => const Color(0xFF17120F);
  @override
  Color get onFondo => const Color(0xFFF3E9E4);
  @override
  Color get superficieContenedorMasBaja => const Color(0xFF0E0B09);
  @override
  Color get superficieContenedorBaja => const Color(0xFF15100D);
  @override
  Color get superficie => const Color(0xFF17120F);
  @override
  Color get superficieContenedor => const Color(0xFF1F1814);
  @override
  Color get superficieContenedorAlta => const Color(0xFF2A211B);
  @override
  Color get superficieContenedorMasAlta => const Color(0xFF362B23);
  @override
  Color get onSuperficie => const Color(0xFFF3E9E4);
  @override
  Color get onSuperficieVariante => const Color(0xFFC9B8B0);

  @override
  Color get contorno => const Color(0xFF8F7E74);
  @override
  Color get contornoVariante => const Color(0xFF362B23);

  @override
  Color get superficieInversa => const Color(0xFFF3E9E4);
  @override
  Color get onSuperficieInversa => const Color(0xFF1C1512);
  @override
  Color get primarioInverso => const Color(0xFF191512);

  @override
  Color get sombra => const Color(0xFF000000);
  @override
  Color get scrim => const Color(0xFF000000);
  @override
  Color get tinteSuperficie => primario;

  @override
  TonoEstado get estadoExito => const TonoEstado(
        fondo: Color(0xFF143A24),
        borde: Color(0xFF2F6A45),
        texto: Color(0xFF6FE39C),
      );
  @override
  TonoEstado get estadoInfo => const TonoEstado(
        fondo: Color(0xFF142A4A),
        borde: Color(0xFF2C4C78),
        texto: Color(0xFF93C5FD),
      );
  @override
  TonoEstado get estadoPendiente => const TonoEstado(
        fondo: Color(0xFF4A2410),
        borde: Color(0xFF7A4420),
        texto: Color(0xFFFFB784),
      );
  @override
  TonoEstado get estadoCritico => const TonoEstado(
        fondo: Color(0xFF4A1210),
        borde: Color(0xFF7A2420),
        texto: Color(0xFFFFB4AB),
      );
  @override
  TonoEstado get estadoArchivado => const TonoEstado(
        fondo: Color(0xFF322B26),
        borde: Color(0xFF4A423C),
        texto: Color(0xFFC9BEB6),
      );
}
