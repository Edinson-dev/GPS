import 'package:flutter/material.dart';
import '../../../../core/utils/distance_formatter.dart';

class ETABottomBar extends StatelessWidget {
  final double durationSeconds;
  final double distanceMeters;
  final String destinationName;
  final VoidCallback onStopNavigation;

  const ETABottomBar({
    super.key,
    required this.durationSeconds,
    required this.distanceMeters,
    required this.destinationName,
    required this.onStopNavigation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barra de Estado de Tráfico Restante en Ruta estilo Waze
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            height: 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: const Color(0xFF334155),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Row(
                children: [
                  Expanded(
                    flex: 75,
                    child: Container(color: const Color(0xFF00E676)), // Fluido 75%
                  ),
                  Expanded(
                    flex: 18,
                    child: Container(color: const Color(0xFFFF9100)), // Moderado 18%
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(color: const Color(0xFFFF1744)), // Congestión / Cierre 7%
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        DistanceFormatter.formatDuration(durationSeconds),
                        style: const TextStyle(
                          color: Color(0xFF00E676),
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Llegada ${DistanceFormatter.calculateETA(durationSeconds)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${DistanceFormatter.formatDistance(distanceMeters)} • $destinationName',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: onStopNavigation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF2E55),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                ),
                child: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
