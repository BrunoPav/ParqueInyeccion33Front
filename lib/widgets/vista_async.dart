import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VistaAsync<T> extends StatelessWidget {
  final AsyncValue<T> valor;
  final Widget Function(T datos) enDatos;
  final VoidCallback alReintentar;

  const VistaAsync({
    super.key,
    required this.valor,
    required this.enDatos,
    required this.alReintentar,
  });

  @override
  Widget build(BuildContext context) {
    return valor.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _VistaError(
        mensaje: error.toString(),
        alReintentar: alReintentar,
      ),
      data: enDatos,
    );
  }
}

class _VistaError extends StatelessWidget {
  final String mensaje;
  final VoidCallback alReintentar;

  const _VistaError({required this.mensaje, required this.alReintentar});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off,
              size: 48,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: alReintentar,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

class VistaVacia extends StatelessWidget {
  final IconData icono;
  final String mensaje;

  const VistaVacia({super.key, required this.icono, required this.mensaje});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 48, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 12),
          Text(mensaje, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
