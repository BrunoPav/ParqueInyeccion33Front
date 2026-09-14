class Cliente {
  final int? id;
  final String nombre;
  final String? contacto;
  final bool activo;

  const Cliente({
    this.id,
    required this.nombre,
    this.contacto,
    this.activo = true,
  });

  Cliente copiarCon({String? nombre, String? contacto, bool? activo}) => Cliente(
        id: id,
        nombre: nombre ?? this.nombre,
        contacto: contacto ?? this.contacto,
        activo: activo ?? this.activo,
      );
}
