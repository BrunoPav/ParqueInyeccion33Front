/// Alturas y anchos fijos de componente que exige la sección "Components"
/// de DESIGN.md.
abstract final class Dimensiones {
  static const double botonPrimario = 52;
  static const double botonSecundario = 48;
  static const double entrada = 48;
  static const double chip = 28;
  static const double filaLista = 56;
  static const double anchoBordeEntrada = 1.5;
  static const double anchoBordeEntradaFoco = 2;
  static const double spinnerBoton = 18;
  static const double anchoTrazoSpinner = 2;
  static const double controlInspeccion = 28;
  static const double iconoPequeno = 16;
  static const double iconoMediano = 32;
  static const double iconoGrande = 48;
  static const double iconoControlInspeccion = 18;
  static const double avatarChico = 32;
  static const double avatarMediano = 40;
  static const double avatarGrande = 48;

  /// No especificado en DESIGN.md; derivado para que el texto no se estire
  /// a todo el ancho de un monitor de escritorio.
  static const double anchoMaximoContenido = 1120;

  static const double anchoMaestro = 360;
  static const double anchoMaximoFormulario = 560;

  /// Ancho fijo para un `trailing` de `ListTile` con precio + menú: sin esto,
  /// `ListTile` mide el ancho natural (sin límite) de ese contenido antes de
  /// achicarlo, y con poco espacio (panel maestro-detalle angosto) tira
  /// "Trailing widget consumes the entire tile width".
  static const double anchoTrailingConMenu = 96;
}
