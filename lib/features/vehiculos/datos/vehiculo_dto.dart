import '../dominio/vehiculo.dart';

class VehiculoDto {
  final int? id;
  final String marca;
  final String modelo;
  final int anio;
  final String patente;
  final int kilometraje;
  final int clienteId;

  const VehiculoDto({
    this.id,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.patente,
    required this.kilometraje,
    required this.clienteId,
  });

  factory VehiculoDto.desdeJson(Map<String, dynamic> json) => VehiculoDto(
        id: json['id'] as int?,
        marca: json['marca'] as String,
        modelo: json['modelo'] as String,
        anio: json['anio'] as int,
        patente: json['patente'] as String,
        kilometraje: json['kilometraje'] as int,
        clienteId: json['clienteId'] as int,
      );

  factory VehiculoDto.desdeDominio(Vehiculo vehiculo) => VehiculoDto(
        id: vehiculo.id,
        marca: vehiculo.marca,
        modelo: vehiculo.modelo,
        anio: vehiculo.anio,
        patente: vehiculo.patente,
        kilometraje: vehiculo.kilometraje,
        clienteId: vehiculo.clienteId,
      );

  Map<String, dynamic> aJson() => {
        'marca': marca,
        'modelo': modelo,
        'anio': anio,
        'patente': patente,
        'kilometraje': kilometraje,
        'clienteId': clienteId,
      };

  Vehiculo aDominio() => Vehiculo(
        id: id,
        marca: marca,
        modelo: modelo,
        anio: anio,
        patente: patente,
        kilometraje: kilometraje,
        clienteId: clienteId,
      );
}
