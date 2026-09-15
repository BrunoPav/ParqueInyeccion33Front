import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utilidades/formatos.dart';
import '../../dominio/servicio.dart';
import '../proveedores/servicios_proveedores.dart';

class FormularioServicio extends ConsumerStatefulWidget {
  final int vehiculoId;
  final Servicio? servicio;

  const FormularioServicio({
    super.key,
    required this.vehiculoId,
    this.servicio,
  });

  @override
  ConsumerState<FormularioServicio> createState() => _FormularioServicioState();
}

class _FormularioServicioState extends ConsumerState<FormularioServicio> {
  final _claveFormulario = GlobalKey<FormState>();
  late final TextEditingController _descripcion;
  late final TextEditingController _precio;
  late DateTime _fecha;
  bool _guardando = false;

  bool get _esEdicion => widget.servicio != null;

  @override
  void initState() {
    super.initState();
    final s = widget.servicio;
    _descripcion = TextEditingController(text: s?.descripcion ?? '');
    _precio = TextEditingController(text: s?.precio.toStringAsFixed(2) ?? '');
    _fecha = s?.fecha ?? DateTime.now();
  }

  @override
  void dispose() {
    _descripcion.dispose();
    _precio.dispose();
    super.dispose();
  }

  Future<void> _elegirFecha() async {
    final ahora = DateTime.now();
    final elegida = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(ahora.year - 20),
      lastDate: ahora,
    );
    if (elegida != null) {
      setState(() => _fecha = elegida);
    }
  }

  Future<void> _guardar() async {
    if (!_claveFormulario.currentState!.validate()) return;

    setState(() => _guardando = true);

    final repositorio = ref.read(repositorioServiciosProvider);
    final datos = Servicio(
      fecha: _fecha,
      descripcion: _descripcion.text.trim(),
      precio: double.parse(_precio.text.trim().replaceAll(',', '.')),
      vehiculoId: widget.vehiculoId,
    );

    try {
      if (_esEdicion) {
        await repositorio.reemplazar(widget.servicio!.id!, datos);
      } else {
        await repositorio.crear(datos);
      }
      ref.invalidate(serviciosPorVehiculoProvider(widget.vehiculoId));
      if (!mounted) return;
      context.pop();
    } catch (error) {
      if (!mounted) return;
      setState(() => _guardando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar servicio' : 'Nuevo servicio'),
      ),
      body: Form(
        key: _claveFormulario,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            InkWell(
              onTap: _elegirFecha,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(Formatos.fecha(_fecha)),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descripcion,
              decoration: const InputDecoration(
                labelText: 'Descripcion',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              validator: (valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return 'La descripcion es obligatoria';
                }
                if (valor.trim().length > 2000) {
                  return 'No puede exceder los 2000 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _precio,
              decoration: const InputDecoration(
                labelText: 'Precio',
                border: OutlineInputBorder(),
                prefixText: '\$ ',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return 'El precio es obligatorio';
                }
                final numero = double.tryParse(valor.trim().replaceAll(',', '.'));
                if (numero == null) {
                  return 'Ingresa un numero valido';
                }
                if (numero < 0) {
                  return 'No puede ser negativo';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _guardando ? null : _guardar,
              icon: _guardando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(_guardando ? 'Guardando...' : 'Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
