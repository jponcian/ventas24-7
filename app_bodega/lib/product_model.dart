class Product {
  final int id;
  final String nombre;
  final String? descripcion;
  final String? unidadMedida;
  final double? precioVenta;
  final double? precioCompra;
  final int? bajoInventario;

  final double? precioVentaPaquete;
  final double? precioVentaUnidad;
  final double? tamPaquete;
  final String? monedaCompra;
  final String? codigoBarras;
  final String? proveedor;

  // Campo local para la app
  int qty = 0;

  Product({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.unidadMedida,
    this.precioVenta,
    this.precioCompra,
    this.bajoInventario,
    this.precioVentaPaquete,
    this.precioVentaUnidad,
    this.tamPaquete,
    this.monedaCompra,
    this.codigoBarras,
    this.proveedor,
    this.stock,
    this.qty = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.tryParse(json['id'].toString()) ?? 0,
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'],
      unidadMedida: json['unidad_medida'],
      precioVenta: double.tryParse(json['precio_venta'].toString()),
      precioCompra: double.tryParse(
        json['costo_unitario']?.toString() ??
            json['precio_compra']?.toString() ??
            '0',
      ),
      bajoInventario: int.tryParse(json['bajo_inventario'].toString()),
      precioVentaPaquete: double.tryParse(
        json['precio_venta_paquete']?.toString() ?? '',
      ),
      precioVentaUnidad: double.tryParse(
        json['precio_venta_unitario']?.toString() ??
            json['precio_venta_unidad']?.toString() ??
            '',
      ),
      tamPaquete: double.tryParse(json['tam_paquete']?.toString() ?? '1'),
      monedaCompra: json['moneda_base'] ?? json['moneda_compra'],
      codigoBarras: json['codigo_barras'],
      proveedor: json['proveedor_nombre'] ?? json['proveedor'],
      stock: double.tryParse(json['stock']?.toString() ?? '0'),
    );
  }

  final double? stock;

  // Helpers para lógica de negocio
  bool get isPaquete => unidadMedida == 'paquete';

  double get precioReal {
    // Prioridad: Unitario > Venta normal
    if (precioVentaUnidad != null && precioVentaUnidad! > 0) {
      return precioVentaUnidad!;
    }
    return precioVenta ?? 0.0;
  }
}
