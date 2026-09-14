import 'dart:async';

import 'package:flutter/material.dart';

/// Ícono de lupa, botón de limpiar automático y debounce — reemplaza el
/// `TextField` inline de la pantalla de clientes, que hoy solo busca con
/// `onSubmitted`.
class BarraBusqueda extends StatefulWidget {
  final String? sugerencia;
  final ValueChanged<String> onBuscar;
  final Duration debounce;

  const BarraBusqueda({
    super.key,
    this.sugerencia,
    required this.onBuscar,
    this.debounce = const Duration(milliseconds: 400),
  });

  @override
  State<BarraBusqueda> createState() => _BarraBusquedaState();
}

class _BarraBusquedaState extends State<BarraBusqueda> {
  final _controlador = TextEditingController();
  Timer? _temporizador;

  @override
  void dispose() {
    _temporizador?.cancel();
    _controlador.dispose();
    super.dispose();
  }

  void _alCambiar(String valor) {
    _temporizador?.cancel();
    _temporizador = Timer(widget.debounce, () => widget.onBuscar(valor.trim()));
    setState(() {});
  }

  void _limpiar() {
    _temporizador?.cancel();
    _controlador.clear();
    widget.onBuscar('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controlador,
      decoration: InputDecoration(
        hintText: widget.sugerencia ?? 'Buscar',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controlador.text.isEmpty
            ? null
            : IconButton(icon: const Icon(Icons.clear), onPressed: _limpiar),
      ),
      onChanged: _alCambiar,
    );
  }
}
