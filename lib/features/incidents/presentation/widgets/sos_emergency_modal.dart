import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class SosEmergencyModal extends StatelessWidget {
  final LatLng currentPos;

  const SosEmergencyModal({super.key, required this.currentPos});

  Future<void> _shareWhatsAppLocation(BuildContext context) async {
    final lat = currentPos.latitude;
    final lng = currentPos.longitude;
    final text = Uri.encodeComponent(
      '🚨 ¡EMERGENCIA WAYPULSE!\nNecesito asistencia inmediata en vía.\nMi ubicación GPS en vivo:\nhttps://maps.google.com/?q=$lat,$lng',
    );
    final url = Uri.parse('https://wa.me/?text=$text');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir WhatsApp')),
        );
      }
    }
  }

  Future<void> _callEmergencyNumber(String number) async {
    final url = Uri.parse('tel:$number');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1B4B),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning_rounded, color: Color(0xFFFF2E55), size: 28),
              SizedBox(width: 8),
              Text(
                'SOS - MODO EMERGENCIA',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Comparte tu ubicación exacta en tiempo real o llama a asistencia médica/grúa',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFFA5B4FC), fontSize: 13),
          ),
          const SizedBox(height: 24),

          // Botón 1: WhatsApp Ubicación GPS
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            icon: const Icon(Icons.share_location_rounded, color: Colors.white, size: 24),
            label: const Text(
              'Enviar Ubicación GPS por WhatsApp',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            onPressed: () => _shareWhatsAppLocation(context),
          ),
          const SizedBox(height: 12),

          // Botón 2: Llamar Emergencias 123
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF2E55),
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            icon: const Icon(Icons.phone_in_talk_rounded, color: Colors.white, size: 24),
            label: const Text(
              'Llamar Línea Nacional 123',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            onPressed: () => _callEmergencyNumber('123'),
          ),
          const SizedBox(height: 12),

          // Botón 3: Llamar Grúa / Asistencia Vial
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF818CF8), width: 1.5),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            icon: const Icon(Icons.car_repair_rounded, color: Color(0xFF818CF8), size: 22),
            label: const Text(
              'Solicitar Grúa / Asistencia en Vía',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
            ),
            onPressed: () => _callEmergencyNumber('#767'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
