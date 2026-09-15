import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/layout/contexto_layout.dart';
import '../../../../shared/shared.dart';
import '../../dominio/vehiculo.dart';
import '../proveedores/vehiculos_proveedores.dart';

class FormularioVehiculo extends ConsumerStatefulWidget {
  final int clienteId;
  final Vehiculo? vehiculo;

  const FormularioVehiculo({
    super.key,
    required this.clienteId,
    this.vehiculo,
  });

  @override
  ConsumerState<FormularioVehiculo> createState() => _FormularioVehiculoState();
}

class _FormularioVehiculoState extends ConsumerState<FormularioVehiculo> {
  final _claveFormulario = GlobalKey<FormState>();
  late final TextEditingController _marca;
  late final TextEditingController _modelo;
  late final TextEditingController _anio;
  late final TextEditingController _patente;
  late final TextEditingController _kilometraje;
  bool _guardando = false;

  bool get _esEdicion => widget.vehiculo != null;

  @override
  void initState() {
    super.initState();
    final v = widget.vehiculo;
    _marca = TextEditingController(text: v?.marca ?? '');
    _modelo = TextEditingController(text: v?.modelo ?? '');
    _anio = TextEditingController(text: v?.anio.toString() ?? '');
    _patente = TextEditingController(text: v?.patente ?? '');
    _kilometraje = TextEditingController(text: v?.kilometraje.toString() ?? '');
  }

  @override
  void dispose() {
    _marca.dispose();
    _modelo.dispose();
    _anio.dispose();
    _patente.dispose();
    _kilometraje.dispose();
    super.dispose();
  }

  String? _validarEntero(String? valor, {required int minimo, required int maximo, required String etiqueta}) {
    if (valor == null || valor.trim().isEmpty) {
      return '$etiqueta es obligatorio';
    }
    final numero = int.tryParse(valor.trim());
    if (numero == null) {
      return 'Ingresa un numero valido';
    }
    if (numero < minimo || numero > maximo) {
      return 'Debe estar entre $minimo y $maximo';
    }
    return null;
  }

  Future<void> _guardar() async {
    if (!_claveFormulario.currentState!.validate()) return;

    setState(() => _guardando = true);

    final repositorio = ref.read(repositorioVehiculosProvider);
    final datos = Vehiculo(
      marca: _marca.text.trim(),
      modelo: _modelo.text.trim(),
      anio: int.parse(_anio.text.trim()),
      patente: _patente.text.trim().toUpperCase(),
      kilometraje: int.parse(_kilometraje.text.trim()),
      clienteId: widget.clienteId,
    );

    try {
      if (_esEdicion) {
        await repositorio.reemplazar(widget.vehiculo!.id!, datos);
      } else {
        await repositorio.crear(datos);
      }
      ref.invalidate(vehiculosPorClienteProvider(widget.clienteId));
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
        title: Text(_esEdicion ? 'Editar vehiculo' : 'Nuevo vehiculo'),
      ),
      body: ContenedorFormulario(
        child: Form(
          key: _claveFormulario,
          child: ListView(
            padding: EdgeInsets.all(context.bordePantalla),
            children: [
              TextFormField(
                controller: _marca,
                decoration: const InputDecoration(
                  labelText: 'Marca',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: (valor) => (valor == null || valor.trim().isEmpty)
                    ? 'La marca es obligatoria'
                    : null,
              ),
              SizedBox(height: context.espaciado.md),
              TextFormField(
                controller: _modelo,
                decoration: const InputDecoration(
                  labelText: 'Modelo',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: (valor) => (valor == null || valor.trim().isEmpty)
                    ? 'El modelo es obligatorio'
                    : null,
              ),
              SizedBox(height: context.espaciado.md),
              TextFormField(
                controller: _anio,
                decoration: const InputDecoration(
                  labelText: 'Anio',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: (valor) => _validarEntero(
                  valor,
                  minimo: 1900,
                  maximo: 2100,
                  etiqueta: 'El anio',
                ),
              ),
              SizedBox(height: context.espaciado.md),
              TextFormField(
                controller: _patente,
                decoration: const InputDecoration(
                  labelText: 'Patente',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.next,
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'La patente es obligatoria';
                  }
                  if (valor.trim().length > 10) {
                    return 'No puede exceder los 10 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: context.espaciado.md),
              TextFormField(
                controller: _kilometraje,
                decoration: const InputDecoration(
                  labelText: 'Kilometraje',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _guardar(),
                validator: (valor) => _validarEntero(
                  valor,
                  minimo: 0,
                  maximo: 9999999,
                  etiqueta: 'El kilometraje',
                ),
              ),
              SizedBox(height: context.espaciado.xl),
              FilledButton.icon(
                onPressed: _guardando ? null : _guardar,
                icon: _guardando
                    ? const SizedBox(
                        width: Dimensiones.spinnerBoton,
                        height: Dimensiones.spinnerBoton,
                        child: CircularProgressIndicator(strokeWidth: Dimensiones.anchoTrazoSpinner),
                      )
                    : const Icon(Icons.save),
                label: Text(_guardando ? 'Guardando...' : 'Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
