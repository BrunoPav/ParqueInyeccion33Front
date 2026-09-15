enum PuntoCorte {
  compacto,
  medio,
  expandido;

  static const double umbralMedio = 640;
  static const double umbralExpandido = 1024;

  static PuntoCorte desdeAncho(double ancho) {
    if (ancho >= umbralExpandido) return PuntoCorte.expandido;
    if (ancho >= umbralMedio) return PuntoCorte.medio;
    return PuntoCorte.compacto;
  }
}
