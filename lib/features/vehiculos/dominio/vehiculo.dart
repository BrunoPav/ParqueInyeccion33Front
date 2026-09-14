class Vehiculo {
  final int? id;
  final String marca;
  final String modelo;
  final int anio;
  final String patente;
  final int kilometraje;
  final int clienteId;

  const Vehiculo({
    this.id,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.patente,
    required this.kilometraje,
    required this.clienteId,
  });

  String get descripcionCorta => '$marca $modelo ($anio)';
}
