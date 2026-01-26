import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'product_model.dart';
import 'api_service.dart';
import 'scanner_screen.dart'; // Usar el nuevo archivo extraído

class ProductFormScreen extends StatefulWidget {
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  late TextEditingController _nombreCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _unidadMedidaCtrl;
  late TextEditingController _precioCompraCtrl;
  late TextEditingController _precioVentaCtrl;
  late TextEditingController _proveedorCtrl;
  late TextEditingController _stockBajoCtrl;
  late TextEditingController _codigoBarrasCtrl;
  late TextEditingController _precioVentaPaqueteCtrl;
  late TextEditingController _precioVentaUnidadCtrl;
  late TextEditingController _tamPaqueteCtrl;

  bool _isLoading = false;
  String _monedaCompra = 'USD';

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(
      text: widget.product?.nombre.replaceAll(' (Paquete)', '') ?? '',
    );
    _descCtrl = TextEditingController(text: widget.product?.descripcion ?? '');
    _unidadMedidaCtrl = TextEditingController(
      text: widget.product?.unidadMedida ?? 'unidad',
    );
    _precioCompraCtrl = TextEditingController(
      text: widget.product?.precioCompra?.toString() ?? '',
    );
    _precioVentaCtrl = TextEditingController(
      text: widget.product?.precioVenta?.toString() ?? '',
    );
    _codigoBarrasCtrl = TextEditingController(
      text: widget.product?.codigoBarras ?? '',
    );
    _proveedorCtrl = TextEditingController(
      text: widget.product?.proveedor ?? '',
    );
    _stockBajoCtrl = TextEditingController(
      text: widget.product?.bajoInventario?.toString() ?? '0',
    );
    _precioVentaPaqueteCtrl = TextEditingController(
      text: widget.product?.precioVentaPaquete?.toString() ?? '',
    );
    _precioVentaUnidadCtrl = TextEditingController(
      text: widget.product?.precioVentaUnidad?.toString() ?? '',
    );
    _tamPaqueteCtrl = TextEditingController(
      text: widget.product?.tamPaquete?.toString() ?? '1',
    );
    _monedaCompra = widget.product?.monedaCompra ?? 'USD';
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _descCtrl.dispose();
    _unidadMedidaCtrl.dispose();
    _precioCompraCtrl.dispose();
    _precioVentaCtrl.dispose();
    _codigoBarrasCtrl.dispose();
    _proveedorCtrl.dispose();
    _stockBajoCtrl.dispose();
    _precioVentaPaqueteCtrl.dispose();
    _precioVentaUnidadCtrl.dispose();
    _tamPaqueteCtrl.dispose();
    super.dispose();
  }

  Future<void> _scanBarcode() async {
    FocusScope.of(context).unfocus();
    final String? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeScannerScreen()),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _codigoBarrasCtrl.text = result;
      });
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    Map<String, dynamic> data = {
      'nombre': _nombreCtrl.text,
      'descripcion': _descCtrl.text,
      'codigo_barras': _codigoBarrasCtrl.text,
      'unidad_medida': _unidadMedidaCtrl.text,
      'tam_paquete': double.tryParse(_tamPaqueteCtrl.text) ?? 1.0,
      'precio_compra': double.tryParse(_precioCompraCtrl.text) ?? 0.0,
      'precio_venta': double.tryParse(_precioVentaCtrl.text) ?? 0.0,
      'precio_venta_paquete':
          double.tryParse(_precioVentaPaqueteCtrl.text) ?? 0.0,
      'precio_venta_unidad':
          double.tryParse(_precioVentaUnidadCtrl.text) ?? 0.0,
      'precio_venta_mediopaquete': 0.0,
      'proveedor': _proveedorCtrl.text.isEmpty
          ? 'General'
          : _proveedorCtrl.text,
      'bajo_inventario': int.tryParse(_stockBajoCtrl.text) ?? 0,
      'moneda_compra': _monedaCompra,
      'vende_media': 0,
    };

    bool success;
    if (widget.product == null) {
      success = await _apiService.createProduct(data);
    } else {
      success = await _apiService.updateProduct(widget.product!.id.abs(), data);
    }

    setState(() => _isLoading = false);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Guardado correctamente'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al guardar'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.product == null ? 'Nuevo Producto' : 'Editar Producto',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E3A8A),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1E3A8A)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('INFORMACIÓN GENERAL'),
              _buildTextField(
                controller: _nombreCtrl,
                label: 'Nombre del Producto',
                icon: Icons.inventory_2_outlined,
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              // CAMPO CON ESCÁNER HABILITADO
              _buildTextField(
                controller: _codigoBarrasCtrl,
                label: 'Código de Barras',
                icon: Icons.qr_code_scanner,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.camera_alt, color: Color(0xFF1E3A8A)),
                  onPressed: _scanBarcode,
                  tooltip: 'Escanear código',
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descCtrl,
                label: 'Descripción',
                icon: Icons.description_outlined,
              ),
              const SizedBox(height: 32),
              _buildSectionTitle('PRECIOS Y CONFIGURACIÓN'),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.currency_exchange,
                      color: Color(0xFF1E3A8A),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Moneda Compra:',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    DropdownButton<String>(
                      value: _monedaCompra,
                      underline: const SizedBox(),
                      items: ['USD', 'BS'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _monedaCompra = val);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _precioCompraCtrl,
                      label: 'Costo ($_monedaCompra)',
                      icon: Icons.download,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _precioVentaCtrl,
                      label: 'Venta (Total)',
                      icon: Icons.upload,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              _buildTextField(
                controller: _precioVentaUnidadCtrl,
                label: 'Precio Venta Unitario (USD)',
                icon: Icons.person_outline,
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _tamPaqueteCtrl,
                      label: 'Tam. Paquete',
                      icon: Icons.apps,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _precioVentaPaqueteCtrl,
                      label: 'Precio Paquete',
                      icon: Icons.inventory_2,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
              _buildSectionTitle('OTROS DATOS'),
              _buildTextField(
                controller: _proveedorCtrl,
                label: 'Proveedor',
                icon: Icons.business_outlined,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _stockBajoCtrl,
                label: 'Alerta Stock Bajo (0 o 1)',
                icon: Icons.warning_amber_rounded,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'GUARDAR PRODUCTO',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 4),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey[500],
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Icon(icon, color: const Color(0xFF1E3A8A), size: 20),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
