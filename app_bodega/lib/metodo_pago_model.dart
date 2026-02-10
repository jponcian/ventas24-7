class MetodoPago {
  final int id;
  final int negocioId;
  final String nombre;
  final bool requiereReferencia;

  MetodoPago({
    required this.id,
    required this.negocioId,
    required this.nombre,
    required this.requiereReferencia,
  });

  factory MetodoPago.fromJson(Map<String, dynamic> json) {
    return MetodoPago(
      id: int.parse(json['id'].toString()),
      negocioId: int.parse(json['negocio_id'].toString()),
      nombre: json['nombre'],
      requiereReferencia: json['requiere_referencia'].toString() == '1',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'negocio_id': negocioId,
      'nombre': nombre,
      'requiere_referencia': requiereReferencia ? 1 : 0,
    };
  }
}
