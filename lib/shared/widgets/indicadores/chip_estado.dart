import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';

enum EstadoTaller { exito, enCurso, pendiente, critico, archivado }

/// Los 5 estados semánticos vía [ColoresEstado]: altura 28, padding
/// `4px 10px`, radio 4, `label-md` en mayúsculas. Sin consumidor hasta que
/// el backend tenga un campo de estado — pieza lista para cuando lo tenga.
class ChipEstado extends StatelessWidget {
  final EstadoTaller estado;
  final String etiqueta;

  const ChipEstado({super.key, required this.estado, required this.etiqueta});

  TonoEstado _tono(BuildContext context) {
    final estados = context.estados;
    return switch (estado) {
      EstadoTaller.exito => estados.exito,
      EstadoTaller.enCurso => estados.enCurso,
      EstadoTaller.pendiente => estados.pendiente,
      EstadoTaller.critico => estados.critico,
      EstadoTaller.archivado => estados.archivado,
    };
  }

  @override
  Widget build(BuildContext context) {
    final tono = _tono(context);
    return SizedBox(
      height: Dimensiones.chip,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tono.fondo,
          border: Border.all(color: tono.borde),
          borderRadius: RadiosTaller.chip,
        ),
        child: Padding(
          padding: PaddingTaller.chip,
          child: Center(
            widthFactor: 1,
            child: Text(
              etiqueta.toUpperCase(),
              style: Tipografia.labelMd.copyWith(color: tono.texto),
            ),
          ),
        ),
      ),
    );
  }
}
