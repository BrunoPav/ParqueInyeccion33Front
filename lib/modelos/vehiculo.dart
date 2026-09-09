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

  factory Vehiculo.desdeJson(Map<String, dynamic> json) => Vehiculo(
        id: json['id'] as int?,
        marca: json['marca'] as String,
        modelo: json['modelo'] as String,
        anio: json['anio'] as int,
        patente: json['patente'] as String,
        kilometraje: json['kilometraje'] as int,
        clienteId: json['clienteId'] as int,
      );

  Map<String, dynamic> aJson() => {
        'marca': marca,
        'modelo': modelo,
        'anio': anio,
        'patente': patente,
        'kilometraje': kilometraje,
        'clienteId': clienteId,
      };

  String get descripcionCorta => '$marca $modelo ($anio)';
}
