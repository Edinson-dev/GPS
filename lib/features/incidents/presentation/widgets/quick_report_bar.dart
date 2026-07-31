import 'package:flutter/material.dart';
import '../../models/incident_model.dart';

class QuickReportBar extends StatelessWidget {
  final Function(IncidentType type, String description) onReport;

  const QuickReportBar({
    super.key,
    required this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    final quickItems = [
      {'type': IncidentType.speedCamera, 'label': 'Fotomulta', 'icon': Icons.camera_alt_rounded, 'color': const Color(0xFFFF2E55)},
      {'type': IncidentType.transitAgent, 'label': 'Retén', 'icon': Icons.local_police_rounded, 'color': const Color(0xFF3B82F6)},
      {'type': IncidentType.pothole, 'label': 'Hueco', 'icon': Icons.warning_amber_rounded, 'color': const Color(0xFFF59E0B)},
      {'type': IncidentType.trafficJam, 'label': 'Tráfico', 'icon': Icons.traffic_rounded, 'color': const Color(0xFFEF4444)},
      {'type': IncidentType.flooding, 'label': 'Lluvia', 'icon': Icons.water_drop_rounded, 'color': const Color(0xFF06B6D4)},
    ];

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF00C8FF).withValues(alpha: 0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 14,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: quickItems.map((item) {
          final type = item['type'] as IncidentType;
          final label = item['label'] as String;
          final icon = item['icon'] as IconData;
          final color = item['color'] as Color;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () {
                onReport(type, '$label reportado en tiempo real');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('⚡ ¡Reporte de $label publicado en tiempo real! (+15 pts)'),
                    backgroundColor: color,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color.withValues(alpha: 0.6)),
                ),
                child: Row(
                  children: [
                    Icon(icon, color: color, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      label,
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
