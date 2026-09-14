import 'package:flutter/material.dart';

import '../../shared/shared.dart';
import 'extensiones/contexto_tema.dart';
import 'extensiones/elevacion_tema.dart';
import 'tokens/tokens.dart';

/// Pantalla de debug, sin ruta asignada: renderiza toda la escala del
/// design-system para compararla a mano contra `mockups/*.png`. No la
/// consume ninguna feature; se abre reemplazando el `home` de la app o
/// desde un test de widget puntual.
class GaleriaTokens extends StatelessWidget {
  const GaleriaTokens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Galería de tokens')),
      body: ListView(
        padding: const EdgeInsets.all(Espaciado.md),
        children: [
          _Seccion(
            titulo: 'Tipografía',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Headline LG', style: Tipografia.headlineLg),
                const Text('Title LG', style: Tipografia.titleLg),
                const Text('Title MD', style: Tipografia.titleMd),
                const Text('Body LG', style: Tipografia.bodyLg),
                const Text('Body MD', style: Tipografia.bodyMd),
                const Text('Body SM', style: Tipografia.bodySm),
                const Text('LABEL LG', style: Tipografia.labelLg),
                const Text('LABEL MD', style: Tipografia.labelMd),
                const Text('LABEL SM', style: Tipografia.labelSm),
                const Text('AF320OK', style: Tipografia.labelMono),
                Text('124.500', style: Tipografia.bodyLg.conCifrasTabulares),
              ],
            ),
          ),
          _Seccion(
            titulo: 'Paleta',
            child: Wrap(
              spacing: Espaciado.xs,
              runSpacing: Espaciado.xs,
              children: [
                _Muestra('primario', context.colores.primary),
                _Muestra('secundario', context.colores.secondary),
                _Muestra('terciario', context.colores.tertiary),
                _Muestra('error', context.colores.error),
                _Muestra('fondo', context.colores.surface),
                _Muestra('superficieMasAlta', context.colores.surfaceContainerHighest),
                _Muestra('exito', context.estados.exito.fondo),
                _Muestra('enCurso', context.estados.enCurso.fondo),
                _Muestra('pendiente', context.estados.pendiente.fondo),
                _Muestra('critico', context.estados.critico.fondo),
                _Muestra('archivado', context.estados.archivado.fondo),
              ],
            ),
          ),
          _Seccion(
            titulo: 'Espaciado',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BarraEspaciado('xxs', context.espaciado.xxs),
                _BarraEspaciado('xs', context.espaciado.xs),
                _BarraEspaciado('sm', context.espaciado.sm),
                _BarraEspaciado('md', context.espaciado.md),
                _BarraEspaciado('lg', context.espaciado.lg),
                _BarraEspaciado('xl', context.espaciado.xl),
                _BarraEspaciado('xxl', context.espaciado.xxl),
              ],
            ),
          ),
const _Seccion(
            titulo: 'Radios',
            child: Wrap(
              spacing: Espaciado.md,
              children: [
                _MuestraRadio('chip', RadiosTaller.chip),
                _MuestraRadio('tarjeta/boton/entrada', RadiosTaller.tarjeta),
                _MuestraRadio('contenedor', RadiosTaller.contenedor),
              ],
            ),
          ),
          _Seccion(
            titulo: 'Elevación',
            child: Row(
              children: [
                _MuestraElevacion('N1', context.elevacion.n1),
                const SizedBox(width: Espaciado.md),
                _MuestraElevacion('N2', context.elevacion.n2),
                const SizedBox(width: Espaciado.md),
                _MuestraElevacion('N3', context.elevacion.n3),
              ],
            ),
          ),
          _Seccion(
            titulo: 'Botones',
            child: Column(
              children: [
                BotonPrimario(etiqueta: 'Guardar', icono: Icons.save, onPressed: () {}),
                SizedBox(height: context.espaciado.sm),
                const BotonPrimario(etiqueta: 'Guardando...', cargando: true, onPressed: null),
                SizedBox(height: context.espaciado.sm),
                BotonSecundario(etiqueta: 'Añadir repuesto', onPressed: () {}),
                SizedBox(height: context.espaciado.sm),
                BotonPeligro(etiqueta: 'Eliminar', onPressed: () {}),
                SizedBox(height: context.espaciado.sm),
                BotonIcono(icono: Icons.settings, onPressed: () {}, tooltip: 'Ajustes'),
              ],
            ),
          ),
          _Seccion(
            titulo: 'Entradas',
            child: Column(
              children: [
                const CampoTexto(etiqueta: 'Nombre'),
                SizedBox(height: context.espaciado.sm),
                const CampoNumerico(etiqueta: 'Kilometraje', minimo: 0, maximo: 999999),
                SizedBox(height: context.espaciado.sm),
                const CampoMoneda(),
                SizedBox(height: context.espaciado.sm),
                const CampoPatente(),
                SizedBox(height: context.espaciado.sm),
                BarraBusqueda(onBuscar: (_) {}),
              ],
            ),
          ),
          _Seccion(
            titulo: 'Superficies',
            child: Column(
              children: [
                FilaLista(
                  filaSuperior: const InsigniaPatente(patente: 'AF320OK'),
                  titulo: 'Toyota Hilux (2020)',
                  descripcion: 'Pick-up cabina doble, motor 1GD-FTV turbo diesel',
                  filaInferior: const Text('124.500 km'),
                  onTap: () {},
                ),
              ],
            ),
          ),
          _Seccion(
            titulo: 'Indicadores',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: context.espaciado.xs,
                  runSpacing: context.espaciado.xs,
                  children: const [
                    ChipEstado(estado: EstadoTaller.exito, etiqueta: 'Listo'),
                    ChipEstado(estado: EstadoTaller.enCurso, etiqueta: 'En curso'),
                    ChipEstado(estado: EstadoTaller.pendiente, etiqueta: 'Pendiente'),
                    ChipEstado(estado: EstadoTaller.critico, etiqueta: 'Crítico'),
                    ChipEstado(estado: EstadoTaller.archivado, etiqueta: 'Archivado'),
                  ],
                ),
                SizedBox(height: context.espaciado.md),
                const FilaInspeccion(titulo: 'Sin marcar', estado: EstadoInspeccion.sinMarcar),
                const FilaInspeccion(titulo: 'Aprobado', estado: EstadoInspeccion.aprobado),
                const FilaInspeccion(titulo: 'Atención', estado: EstadoInspeccion.atencion),
                const FilaInspeccion(titulo: 'Falla', estado: EstadoInspeccion.falla),
              ],
            ),
          ),
          _Seccion(
            titulo: 'Retroalimentación',
            child: Column(
              children: [
                VistaVacia(
                  icono: Icons.people_outline,
                  titulo: 'No hay clientes activos',
                  etiquetaAccion: 'Crear el primero',
                  onAccion: () {},
                ),
                SizedBox(height: context.espaciado.md),
                VistaError(mensaje: 'No se pudo conectar con el servidor', alReintentar: () {}),
                SizedBox(height: context.espaciado.md),
                const EsqueletoFilaLista(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Seccion extends StatelessWidget {
  final String titulo;
  final Widget child;

  const _Seccion({required this.titulo, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Espaciado.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: Tipografia.titleLg),
          const SizedBox(height: Espaciado.sm),
          child,
        ],
      ),
    );
  }
}

class _Muestra extends StatelessWidget {
  final String etiqueta;
  final Color color;

  const _Muestra(this.etiqueta, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: color,
            borderRadius: RadiosTaller.tarjeta,
            border: Border.all(color: context.colores.outlineVariant),
          ),
        ),
        const SizedBox(height: Espaciado.xxs),
        Text(etiqueta, style: Tipografia.labelSm),
      ],
    );
  }
}

class _MuestraRadio extends StatelessWidget {
  final String etiqueta;
  final BorderRadius radio;

  const _MuestraRadio(this.etiqueta, this.radio);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            border: Border.all(color: context.colores.outline, width: 2),
            borderRadius: radio,
          ),
        ),
        const SizedBox(height: Espaciado.xxs),
        Text(etiqueta, style: Tipografia.labelSm),
      ],
    );
  }
}

class _MuestraElevacion extends StatelessWidget {
  final String etiqueta;
  final NivelElevacion nivel;

  const _MuestraElevacion(this.etiqueta, this.nivel);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 64,
            decoration: BoxDecoration(
              color: context.colores.surfaceContainerLowest,
              borderRadius: RadiosTaller.tarjeta,
              border: Border.all(color: nivel.colorBorde, width: nivel.anchoBorde),
              boxShadow: nivel.sombra,
            ),
          ),
          const SizedBox(height: Espaciado.xxs),
          Text(etiqueta, style: Tipografia.labelSm),
        ],
      ),
    );
  }
}

class _BarraEspaciado extends StatelessWidget {
  final String etiqueta;
  final double valor;

  const _BarraEspaciado(this.etiqueta, this.valor);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Espaciado.xxs),
      child: Row(
        children: [
          SizedBox(width: 40, child: Text(etiqueta, style: Tipografia.labelSm)),
          Container(width: valor, height: 12, color: context.colores.secondary),
          const SizedBox(width: Espaciado.xs),
          Text('${valor.toInt()}px', style: Tipografia.bodySm),
        ],
      ),
    );
  }
}
