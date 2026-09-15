import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/layout/contexto_layout.dart';
import '../../../../shared/shared.dart';
import '../../dominio/cliente.dart';
import '../proveedores/clientes_proveedores.dart';

class FormularioCliente extends ConsumerStatefulWidget {
  final Cliente? cliente;

  const FormularioCliente({super.key, this.cliente});

  @override
  ConsumerState<FormularioCliente> createState() => _FormularioClienteState();
}

class _FormularioClienteState extends ConsumerState<FormularioCliente> {
  final _claveFormulario = GlobalKey<FormState>();
  late final TextEditingController _nombre;
  late final TextEditingController _contacto;
  bool _guardando = false;

  bool get _esEdicion => widget.cliente != null;

  @override
  void initState() {
    super.initState();
    _nombre = TextEditingController(text: widget.cliente?.nombre ?? '');
    _contacto = TextEditingController(text: widget.cliente?.contacto ?? '');
  }

  @override
  void dispose() {
    _nombre.dispose();
    _contacto.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_claveFormulario.currentState!.validate()) return;

    setState(() => _guardando = true);

    final repositorio = ref.read(repositorioClientesProvider);
    final datos = Cliente(
      nombre: _nombre.text.trim(),
      contacto: _contacto.text.trim().isEmpty ? null : _contacto.text.trim(),
    );

    try {
      if (_esEdicion) {
        await repositorio.reemplazar(widget.cliente!.id!, datos);
      } else {
        await repositorio.crear(datos);
      }
      ref.invalidate(clientesProvider);
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
        title: Text(_esEdicion ? 'Editar cliente' : 'Nuevo cliente'),
      ),
      body: ContenedorFormulario(
        child: Form(
          key: _claveFormulario,
          child: ListView(
            padding: EdgeInsets.all(context.bordePantalla),
            children: [
              TextFormField(
                controller: _nombre,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  if (valor.trim().length > 100) {
                    return 'No puede exceder los 100 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: context.espaciado.md),
              TextFormField(
                controller: _contacto,
                decoration: const InputDecoration(
                  labelText: 'Contacto',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _guardar(),
                validator: (valor) {
                  if (valor != null && valor.trim().length > 100) {
                    return 'No puede exceder los 100 caracteres';
                  }
                  return null;
                },
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
