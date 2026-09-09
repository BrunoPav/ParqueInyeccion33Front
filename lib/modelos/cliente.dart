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

  factory Cliente.desdeJson(Map<String, dynamic> json) => Cliente(
        id: json['id'] as int?,
        nombre: json['nombre'] as String,
        contacto: json['contacto'] as String?,
        activo: json['activo'] as bool? ?? true,
      );

  Map<String, dynamic> aJson() => {
        'nombre': nombre,
        'contacto': contacto,
      };

  Cliente copiarCon({String? nombre, String? contacto, bool? activo}) => Cliente(
        id: id,
        nombre: nombre ?? this.nombre,
        contacto: contacto ?? this.contacto,
        activo: activo ?? this.activo,
      );
}
