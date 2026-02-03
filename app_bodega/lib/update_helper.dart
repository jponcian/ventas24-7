import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'api_service.dart';

class UpdateHelper {
  static Future<void> checkUpdate(BuildContext context) async {
    final ApiService apiService = ApiService();
    try {
      // 1. Obtener información de la versión actual
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final int currentVersionCode = int.tryParse(packageInfo.buildNumber) ?? 0;

      // 2. Consultar al servidor la última versión
      final updateData = await apiService.checkVersion();

      if (updateData['ok'] == true) {
        final int latestVersionCode = updateData['latest_version_code'] ?? 0;
        final String downloadUrl = updateData['download_url'] ?? '';
        final String releaseNotes =
            updateData['release_notes'] ?? 'Nueva versión disponible.';
        final bool forceUpdate = updateData['force_update'] ?? false;

        // 3. Comparar
        if (latestVersionCode > currentVersionCode) {
          if (context.mounted) {
            _showUpdateDialog(context, downloadUrl, releaseNotes, forceUpdate);
          }
        }
      }
    } catch (e) {
      debugPrint('Error verificando actualización: $e');
    }
  }

  static void _showUpdateDialog(
    BuildContext context,
    String url,
    String notes,
    bool force,
  ) {
    showDialog(
      context: context,
      barrierDismissible: !force,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.system_update, color: Color(0xFF1E3A8A)),
            SizedBox(width: 10),
            Text('Actualización Disponible'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Una nueva versión del sistema está lista para descargar.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(notes),
            if (force) ...[
              const SizedBox(height: 16),
              const Text(
                'Esta actualización es obligatoria para continuar usando el sistema.',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
          ],
        ),
        actions: [
          if (!force)
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('LUEGO'),
            ),
          FilledButton(
            onPressed: () async {
              final Uri uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A8A),
            ),
            child: const Text('ACTUALIZAR AHORA'),
          ),
        ],
      ),
    );
  }
}
