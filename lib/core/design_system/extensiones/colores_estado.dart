import 'package:flutter/material.dart';

import '../tokens/paleta.dart';

/// Los 5 estados semánticos del taller (listo, en curso, pendiente, crítico,
/// archivado), expuestos vía tema porque [ColorScheme] no tiene slots para
/// ellos.
class ColoresEstado extends ThemeExtension<ColoresEstado> {
  final TonoEstado exito;
  final TonoEstado enCurso;
  final TonoEstado pendiente;
  final TonoEstado critico;
  final TonoEstado archivado;

  const ColoresEstado({
    required this.exito,
    required this.enCurso,
    required this.pendiente,
    required this.critico,
    required this.archivado,
  });

  factory ColoresEstado.desdePaleta(Paleta paleta) {
    return ColoresEstado(
      exito: paleta.estadoExito,
      enCurso: paleta.estadoInfo,
      pendiente: paleta.estadoPendiente,
      critico: paleta.estadoCritico,
      archivado: paleta.estadoArchivado,
    );
  }

  @override
  ColoresEstado copyWith({
    TonoEstado? exito,
    TonoEstado? enCurso,
    TonoEstado? pendiente,
    TonoEstado? critico,
    TonoEstado? archivado,
  }) {
    return ColoresEstado(
      exito: exito ?? this.exito,
      enCurso: enCurso ?? this.enCurso,
      pendiente: pendiente ?? this.pendiente,
      critico: critico ?? this.critico,
      archivado: archivado ?? this.archivado,
    );
  }

  @override
  ColoresEstado lerp(ThemeExtension<ColoresEstado>? other, double t) {
    if (other is! ColoresEstado) return this;
    return ColoresEstado(
      exito: TonoEstado.lerp(exito, other.exito, t),
      enCurso: TonoEstado.lerp(enCurso, other.enCurso, t),
      pendiente: TonoEstado.lerp(pendiente, other.pendiente, t),
      critico: TonoEstado.lerp(critico, other.critico, t),
      archivado: TonoEstado.lerp(archivado, other.archivado, t),
    );
  }
}
