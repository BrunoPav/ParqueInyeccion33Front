import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';

enum EstadoInspeccion { sinMarcar, aprobado, atencion, falla }

/// La fila de checklist MPI: altura mínima 56, control 28×28 en el
/// extremo, 4 estados. Sin consumidor hasta que el backend tenga
/// checklists de inspección — pieza lista para cuando los tenga.
class FilaInspeccion extends StatelessWidget {
  final String titulo;
  final EstadoInspeccion estado;
  final ValueChanged<EstadoInspeccion>? onCambiar;

  const FilaInspeccion({
    super.key,
    required this.titulo,
    required this.estado,
    this.onCambiar,
  });

  Color _color(BuildContext context) {
    return switch (estado) {
      EstadoInspeccion.sinMarcar => context.colores.outline,
      EstadoInspeccion.aprobado => context.estados.exito.texto,
      EstadoInspeccion.atencion => context.colores.secondary,
      EstadoInspeccion.falla => context.estados.critico.texto,
    };
  }

  IconData? get _icono {
    return switch (estado) {
      EstadoInspeccion.sinMarcar => null,
      EstadoInspeccion.aprobado => Icons.check,
      EstadoInspeccion.atencion => Icons.priority_high,
      EstadoInspeccion.falla => Icons.close,
    };
  }

  EstadoInspeccion get _siguiente {
    final valores = EstadoInspeccion.values;
    return valores[(estado.index + 1) % valores.length];
  }

  @override
  Widget build(BuildContext context) {
    final color = _color(context);
    final relleno = estado == EstadoInspeccion.sinMarcar;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: Dimensiones.filaLista),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.espaciado.md),
              child: Text(titulo, style: context.textos.bodyLarge),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: context.espaciado.md),
            child: InkWell(
              onTap: onCambiar == null ? null : () => onCambiar!(_siguiente),
              customBorder: const CircleBorder(),
              child: Container(
                width: Dimensiones.controlInspeccion,
                height: Dimensiones.controlInspeccion,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: relleno ? Colors.transparent : color,
                  border: Border.all(color: color, width: 2),
                ),
                child: _icono == null
                    ? null
                    : Icon(
                        _icono,
                        size: Dimensiones.iconoControlInspeccion,
                        color: context.colores.surface,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
