import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'fiado_model.dart';
import 'fiado_detail_screen.dart';

class ClienteCuentaScreen extends StatelessWidget {
  final Cliente cliente;
  final List<Fiado> fiados;
  final VoidCallback onRefresh;

  const ClienteCuentaScreen({
    super.key,
    required this.cliente,
    required this.fiados,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    // Ordenar fiados por fecha descendente
    final sortedFiados = List<Fiado>.from(fiados)
      ..sort((a, b) => b.fecha.compareTo(a.fecha));

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Cuenta de Cliente',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E3A8A),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen del Cliente
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: cliente.deudaTotal > 0
                            ? Colors.red[50]
                            : Colors.green[50],
                        child: Icon(
                          Icons.person,
                          size: 30,
                          color: cliente.deudaTotal > 0
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cliente.nombre,
                              style: GoogleFonts.outfit(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (cliente.cedula != null)
                              Text(
                                'C.I.: ${cliente.cedula}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            if (cliente.telefono != null)
                              Text(
                                'Telf: ${cliente.telefono}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Deuda Total',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '\$${cliente.deudaTotal.toStringAsFixed(2)} USD',
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: cliente.deudaTotal > 0
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Título de la lista
            Text(
              'Historial de Créditos',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E3A8A),
              ),
            ),
            const SizedBox(height: 12),

            if (sortedFiados.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Text('No hay créditos registrados para este cliente'),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sortedFiados.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final fiado = sortedFiados[index];
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey[200]!),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      title: Row(
                        children: [
                          Text(
                            'Crédito #${fiado.id}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          _buildStatusBadge(fiado.estado),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('dd/MM/yyyy HH:mm').format(fiado.fecha),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            'Total: \$${fiado.totalUsd.toStringAsFixed(2)} - Saldo: \$${fiado.saldoPendiente.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: fiado.saldoPendiente > 0
                                  ? Colors.red[700]
                                  : Colors.green[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FiadoDetailScreen(fiadoId: fiado.id),
                          ),
                        );
                        onRefresh();
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String estado) {
    Color color;
    String label;
    switch (estado.toLowerCase()) {
      case 'pagado':
        color = Colors.green;
        label = 'PAGADO';
        break;
      case 'pendiente':
        color = Colors.orange;
        label = 'PENDIENTE';
        break;
      case 'cancelado':
        color = Colors.red;
        label = 'CANCELADO';
        break;
      default:
        color = Colors.grey;
        label = estado.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
