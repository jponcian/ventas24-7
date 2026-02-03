class Cliente {
  final int id;
  final String nombre;
  final String? cedula;
  final String? telefono;
  final String? direccion;
  final double deudaTotal;
  final DateTime? createdAt;

  Cliente({
    required this.id,
    required this.nombre,
    this.cedula,
    this.telefono,
    this.direccion,
    required this.deudaTotal,
    this.createdAt,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: int.tryParse(json['id'].toString()) ?? 0,
      nombre: json['nombre'] ?? '',
      cedula: json['cedula']?.toString(),
      telefono: json['telefono']?.toString(),
      direccion: json['direccion']?.toString(),
      deudaTotal: double.tryParse(json['deuda_total']?.toString() ?? '0') ?? 0,
      createdAt: json['created_at'] != null || json['fecha_creacion'] != null
          ? DateTime.tryParse(
              json['created_at'] ?? json['fecha_creacion'] ?? '',
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'cedula': cedula,
      'telefono': telefono,
      'direccion': direccion,
      'deuda_total': deudaTotal,
    };
  }
}

class Fiado {
  final int id;
  final int clienteId;
  final String? clienteNombre;
  final double totalUsd;
  final double totalBs;
  final double saldoPendiente;
  final String estado; // 'pendiente', 'pagado', 'cancelado'
  final DateTime fecha;
  final List<FiadoDetalle>? detalles;

  Fiado({
    required this.id,
    required this.clienteId,
    this.clienteNombre,
    required this.totalUsd,
    required this.totalBs,
    required this.saldoPendiente,
    required this.estado,
    required this.fecha,
    this.detalles,
  });

  factory Fiado.fromJson(Map<String, dynamic> json) {
    return Fiado(
      id: int.tryParse(json['id'].toString()) ?? 0,
      clienteId: int.tryParse(json['cliente_id'].toString()) ?? 0,
      clienteNombre: json['cliente_nombre'],
      totalUsd: double.tryParse(json['total_usd']?.toString() ?? '0') ?? 0,
      totalBs: double.tryParse(json['total_bs']?.toString() ?? '0') ?? 0,
      saldoPendiente:
          double.tryParse(json['saldo_pendiente']?.toString() ?? '0') ?? 0,
      estado: json['estado'] ?? 'pendiente',
      fecha: DateTime.tryParse(json['fecha'] ?? '') ?? DateTime.now(),
      detalles: json['detalles'] != null
          ? (json['detalles'] as List)
                .map((d) => FiadoDetalle.fromJson(d))
                .toList()
          : null,
    );
  }
}

class FiadoDetalle {
  final int id;
  final int fiadoId;
  final int productoId;
  final String productoNombre;
  final double cantidad;
  final double precioUnitarioBs;
  final double precioUnitarioUsd;
  final double subtotalBs;
  final double subtotalUsd;

  FiadoDetalle({
    required this.id,
    required this.fiadoId,
    required this.productoId,
    required this.productoNombre,
    required this.cantidad,
    required this.precioUnitarioBs,
    required this.precioUnitarioUsd,
    required this.subtotalBs,
    required this.subtotalUsd,
  });

  factory FiadoDetalle.fromJson(Map<String, dynamic> json) {
    return FiadoDetalle(
      id: int.tryParse(json['id'].toString()) ?? 0,
      fiadoId: int.tryParse(json['fiado_id'].toString()) ?? 0,
      productoId: int.tryParse(json['producto_id'].toString()) ?? 0,
      productoNombre: json['producto_nombre'] ?? '',
      cantidad: double.tryParse(json['cantidad']?.toString() ?? '0') ?? 0,
      precioUnitarioBs:
          double.tryParse(json['precio_unitario_bs']?.toString() ?? '0') ?? 0,
      precioUnitarioUsd:
          double.tryParse(json['precio_unitario_usd']?.toString() ?? '0') ?? 0,
      subtotalBs: double.tryParse(json['subtotal_bs']?.toString() ?? '0') ?? 0,
      subtotalUsd:
          double.tryParse(json['subtotal_usd']?.toString() ?? '0') ?? 0,
    );
  }
}

class Abono {
  final int id;
  final int fiadoId;
  final double montoBs;
  final double montoUsd;
  final DateTime fecha;
  final String? observaciones;

  Abono({
    required this.id,
    required this.fiadoId,
    required this.montoBs,
    required this.montoUsd,
    required this.fecha,
    this.observaciones,
  });

  factory Abono.fromJson(Map<String, dynamic> json) {
    return Abono(
      id: int.tryParse(json['id'].toString()) ?? 0,
      fiadoId: int.tryParse(json['fiado_id'].toString()) ?? 0,
      montoBs: double.tryParse(json['monto_bs']?.toString() ?? '0') ?? 0,
      montoUsd: double.tryParse(json['monto_usd']?.toString() ?? '0') ?? 0,
      fecha: DateTime.tryParse(json['fecha'] ?? '') ?? DateTime.now(),
      observaciones: json['observaciones'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fiado_id': fiadoId,
      'monto_bs': montoBs,
      'monto_usd': montoUsd,
      'observaciones': observaciones,
    };
  }
}
