import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'product_model.dart';
import 'api_service.dart';
import 'scanner_screen.dart';
import 'utils.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  late TextEditingController _codigoInternoCtrl;
  late TextEditingController _precioVentaPaqueteCtrl;
  late TextEditingController _precioVentaUnidadCtrl;
  late TextEditingController _precioCompraUnidadCtrl;
  late TextEditingController _tamPaqueteCtrl;
  late TextEditingController _stockCtrl;
  late TextEditingController _vencimientoCtrl;
  late TextEditingController _marcaCtrl;

  bool _isLoading = false;
  bool _vendePorPeso = false;
  String _monedaCompra = 'USD';
  List<String> _providers = [];
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(
      text: widget.product?.nombre.replaceAll(' (Paquete)', '') ?? '',
    );
    _marcaCtrl = TextEditingController(text: widget.product?.marca ?? '');
    _descCtrl = TextEditingController(text: widget.product?.descripcion ?? '');
    _unidadMedidaCtrl = TextEditingController(
      text: widget.product?.unidadMedida ?? 'unidad',
    );
    double cpUnitario = widget.product?.precioCompra ?? 0;
    double tamPack = widget.product?.tamPaquete ?? 1;
    if (tamPack <= 0) tamPack = 1;

    _precioCompraCtrl = TextEditingController(
      text: (cpUnitario * tamPack).toStringAsFixed(2),
    );
    _precioVentaCtrl = TextEditingController(
      text: widget.product?.precioVenta?.toString() ?? '',
    );
    _codigoBarrasCtrl = TextEditingController(
      text: widget.product?.codigoBarras ?? '',
    );
    _codigoInternoCtrl = TextEditingController(
      text: widget.product?.codigoInterno ?? '',
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
    _precioCompraUnidadCtrl = TextEditingController(
      text: cpUnitario.toStringAsFixed(2),
    );
    _tamPaqueteCtrl = TextEditingController(
      text: widget.product?.tamPaquete?.toString() ?? '1',
    );
    _stockCtrl = TextEditingController(
      text: widget.product?.stock?.toString() ?? '0',
    );
    _vencimientoCtrl = TextEditingController(
      text: widget.product?.fechaVencimiento ?? '',
    );
    _monedaCompra = widget.product?.monedaCompra ?? 'USD';
    _vendePorPeso = widget.product?.vendePorPeso ?? false;

    _loadProviders();
  }

  Future<void> _loadProviders() async {
    try {
      final list = await _apiService.getProviders();
      setState(() {
        _providers = list;
      });
    } catch (e) {
      print('Error al cargar proveedores: $e');
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _descCtrl.dispose();
    _unidadMedidaCtrl.dispose();
    _precioCompraCtrl.dispose();
    _precioVentaCtrl.dispose();
    _codigoBarrasCtrl.dispose();
    _codigoInternoCtrl.dispose();
    _proveedorCtrl.dispose();
    _stockBajoCtrl.dispose();
    _precioVentaPaqueteCtrl.dispose();
    _precioVentaUnidadCtrl.dispose();
    _precioCompraUnidadCtrl.dispose();
    _tamPaqueteCtrl.dispose();
    _stockCtrl.dispose();
    _marcaCtrl.dispose();
    _vencimientoCtrl.dispose();
    super.dispose();
  }

  void _updatePricesFromPackage() {
    double cp = double.tryParse(_precioCompraCtrl.text) ?? 0;
    double tp = double.tryParse(_tamPaqueteCtrl.text) ?? 1;
    if (tp == 0) tp = 1;
    String val = (cp / tp).toStringAsFixed(2);
    if (_precioCompraUnidadCtrl.text != val) {
      _precioCompraUnidadCtrl.text = val;
    }
  }

  void _updatePricesFromUnit() {
    double cu = double.tryParse(_precioCompraUnidadCtrl.text) ?? 0;
    double tp = double.tryParse(_tamPaqueteCtrl.text) ?? 1;
    String val = (cu * tp).toStringAsFixed(2);
    if (_precioCompraCtrl.text != val) {
      _precioCompraCtrl.text = val;
    }
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

  Future<void> _selectDate() async {
    DateTime initialDate = DateTime.now();
    if (_vencimientoCtrl.text.isNotEmpty) {
      try {
        initialDate = DateTime.parse(_vencimientoCtrl.text);
      } catch (_) {}
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1E3A8A),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E3A8A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _vencimientoCtrl.text = picked.toString().split(' ')[0];
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    String? imageUrl;
    if (_imageFile != null) {
      imageUrl = await _apiService.uploadProductImage(_imageFile!);
    }

    // Calcular el costo unitario real
    double costoPaquete = double.tryParse(_precioCompraCtrl.text) ?? 0.0;
    double tamPaquete = double.tryParse(_tamPaqueteCtrl.text) ?? 1.0;
    if (tamPaquete <= 0) tamPaquete = 1.0;
    double costoUnitarioReal = costoPaquete / tamPaquete;

    Map<String, dynamic> data = {
      'nombre': _nombreCtrl.text,
      'marca': _marcaCtrl.text,
      'descripcion': _descCtrl.text,
      'codigo_barras': _codigoBarrasCtrl.text,
      'codigo_interno': _codigoInternoCtrl.text,
      'unidad_medida': _unidadMedidaCtrl.text,
      'tam_paquete': tamPaquete,
      'precio_compra': costoUnitarioReal, // Enviar el costo unitario calculado
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
      'vende_por_peso': _vendePorPeso ? 1 : 0,
      'stock': double.tryParse(_stockCtrl.text) ?? 0.0,
      'fecha_vencimiento': _vencimientoCtrl.text.isEmpty
          ? null
          : _vencimientoCtrl.text,
      'imagen': imageUrl,
    };

    bool success = false;
    Map<String, dynamic> result;
    try {
      if (widget.product == null) {
        result = await _apiService.createProduct(data);
      } else {
        result = await _apiService.updateProduct(
          widget.product!.id.abs(),
          data,
        );
      }

      if (!result['success']) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error al guardar: ${result['message'] ?? "Error desconocido"}',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        success = true;
      }
    } catch (e) {
      success = false;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error inesperado: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
              _buildSectionTitle('IMAGEN DEL PRODUCTO'),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: _imageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.file(_imageFile!, fit: BoxFit.cover),
                          )
                        : const Icon(
                            Icons.add_a_photo_outlined,
                            size: 50,
                            color: Color(0xFF1E3A8A),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('INFORMACIÓN GENERAL'),
              _buildTextField(
                controller: _nombreCtrl,
                label: 'Nombre del Producto',
                icon: Icons.inventory_2_outlined,
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _marcaCtrl,
                label: 'Marca',
                icon: Icons.branding_watermark_outlined,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _codigoInternoCtrl,
                      label: 'Código Interno (A001)',
                      icon: Icons.tag,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _codigoBarrasCtrl,
                      label: 'Código de Barras',
                      icon: Icons.qr_code_scanner,
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Color(0xFF1E3A8A),
                        ),
                        onPressed: _scanBarcode,
                        tooltip: 'Escanear código',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // CAMPO DESCRIPCION
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
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.currency_exchange,
                          color: Color(0xFF10B981),
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _monedaCompra = val);
                            }
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    _buildTextField(
                      controller: _precioCompraCtrl,
                      label: 'Costo por Paquete ($_monedaCompra)',
                      icon: Icons.shopping_bag_outlined,
                      keyboardType: TextInputType.number,
                      inputFormatters: [SlidingDecimalFormatter()],
                      onChanged: (_) {
                        _updatePricesFromPackage();
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _tamPaqueteCtrl,
                            label: 'Unidades x Paquete',
                            icon: Icons.numbers,
                            keyboardType: TextInputType.number,
                            onChanged: (_) {
                              _updatePricesFromPackage();
                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _precioCompraUnidadCtrl,
                            label: 'Costo Unitario ($_monedaCompra)',
                            icon: Icons.monetization_on_outlined,
                            keyboardType: TextInputType.number,
                            inputFormatters: [SlidingDecimalFormatter()],
                            onChanged: (_) {
                              _updatePricesFromUnit();
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  const Text(
                    '¿Vende por Peso?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Switch(
                    value: _vendePorPeso,
                    onChanged: (val) {
                      setState(() {
                        _vendePorPeso = val;
                      });
                    },
                    activeThumbColor: const Color(0xFF1E3A8A),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text(
                    '¿Vende por Paquete?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Switch(
                    value: _unidadMedidaCtrl.text == 'paquete',
                    onChanged: (val) {
                      setState(() {
                        _unidadMedidaCtrl.text = val ? 'paquete' : 'unidad';
                      });
                    },
                    activeThumbColor: const Color(0xFF1E3A8A),
                  ),
                ],
              ),

              if (_unidadMedidaCtrl.text == 'paquete') ...[
                const SizedBox(height: 16),
                _buildPriceCalculationSection(
                  title: 'PRECIO VENTA PAQUETE',
                  controller: _precioVentaPaqueteCtrl,
                  basePrice: double.tryParse(_precioCompraCtrl.text) ?? 0,
                ),
              ],

              const SizedBox(height: 16),
              _buildPriceCalculationSection(
                title: 'PRECIO VENTA DETAL (UNITARIO)',
                controller: _precioVentaUnidadCtrl,
                basePrice: double.tryParse(_precioCompraUnidadCtrl.text) ?? 0,
              ),

              const SizedBox(height: 32),
              _buildSectionTitle('OTROS DATOS'),
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return _providers;
                  }
                  return _providers.where((String option) {
                    return option.toLowerCase().contains(
                      textEditingValue.text.toLowerCase(),
                    );
                  });
                },
                onSelected: (String selection) {
                  _proveedorCtrl.text = selection;
                },
                fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                  // Sincronizar con el controlador principal
                  if (controller.text != _proveedorCtrl.text &&
                      _proveedorCtrl.text.isNotEmpty &&
                      controller.text.isEmpty) {
                    controller.text = _proveedorCtrl.text;
                  }
                  // Asegurarse de quitar el listener anterior si existe (aunque fieldViewBuilder rebuild puede ser tricky, aquí es simple)
                  // Mejor opción: asignar listener solo una vez o chequear si ya está sincronizado es difícil.
                  // Simplificación: Asignar siempre, el controller de Autocomplete cambia si el widget se reconstruye?
                  // Generalmente fieldViewBuilder se llama una vez a menos que cambie Autocomplete.
                  controller.removeListener(() {
                    _proveedorCtrl.text = controller.text;
                  }); // Prevent duplicates hacky way, or check API.
                  // Realmente, solo necesitamos setear el valor de _proveedorCtrl cuando cambia.
                  controller.addListener(() {
                    _proveedorCtrl.text = controller.text;
                  });

                  return _buildTextField(
                    controller: controller,
                    focusNode: focusNode,
                    label: 'Proveedor',
                    icon: Icons.business_outlined,
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF10B981),
                      ),
                      onPressed: () {
                        // Force show options
                        if (focusNode.hasFocus) {
                          focusNode.unfocus();
                          Future.delayed(const Duration(milliseconds: 50), () {
                            focusNode.requestFocus();
                          });
                        } else {
                          focusNode.requestFocus();
                        }
                      },
                    ),
                  );
                },
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 48,
                        constraints: const BoxConstraints(maxHeight: 250),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1),
                          itemBuilder: (BuildContext context, int index) {
                            final String option = options.elementAt(index);
                            return ListTile(
                              title: Text(
                                option,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF1E3A8A),
                                ),
                              ),
                              onTap: () => onSelected(option),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _stockBajoCtrl,
                label: 'Alerta Stock Bajo (Quedan...)',
                icon: Icons.notifications_active_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _stockCtrl,
                label: 'Stock Actual (Inventario)',
                icon: Icons.inventory,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _vencimientoCtrl,
                label: 'Fecha de Vencimiento',
                icon: Icons.event_available_outlined,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.date_range, color: Color(0xFF1E3A8A)),
                  onPressed: _selectDate,
                ),
                onChanged:
                    (_) {}, // Prevent manual editing if desired, or let it be
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

  Widget _buildPriceCalculationSection({
    required String title,
    required TextEditingController controller,
    required double basePrice,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A8A).withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF1E3A8A).withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: controller,
            label: 'Precio de Venta',
            icon: Icons.sell_outlined,
            keyboardType: TextInputType.number,
            inputFormatters: [SlidingDecimalFormatter()],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _marginBtn(controller, basePrice, 10),
              _marginBtn(controller, basePrice, 15),
              _marginBtn(controller, basePrice, 20),
              _marginBtn(controller, basePrice, 30),
            ],
          ),
        ],
      ),
    );
  }

  Widget _marginBtn(TextEditingController ctrl, double base, int percent) {
    return GestureDetector(
      onTap: () {
        if (base <= 0) return;
        double price = base * (1 + (percent / 100));
        setState(() {
          ctrl.text = price.toStringAsFixed(2);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF1E3A8A).withValues(alpha: 0.2),
          ),
        ),
        child: Text(
          '+$percent%',
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E3A8A),
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
    List<TextInputFormatter>? inputFormatters,
    Function(String)? onChanged,
    FocusNode? focusNode,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        validator: validator,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        style: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
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
