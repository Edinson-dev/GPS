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
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle de drag al estilo Waze
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFDDDDE8),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Barra de tráfico de la ruta restante
          Container(
            margin: const EdgeInsets.only(bottom: 14),
            height: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: const Color(0xFFEEEEF5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: const Row(
                children: [
                  Expanded(
                    flex: 75,
                    child: ColoredBox(color: Color(0xFF34C759)), // Verde fluido
                  ),
                  Expanded(
                    flex: 18,
                    child: ColoredBox(color: Color(0xFFFF9500)), // Naranja moderado
                  ),
                  Expanded(
                    flex: 7,
                    child: ColoredBox(color: Color(0xFFFF3B30)), // Rojo congestión
                  ),
                ],
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Info de tiempo y llegada
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          DistanceFormatter.formatDuration(durationSeconds),
                          style: const TextStyle(
                            color: Color(0xFF1A1A2E),
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Llegada ${DistanceFormatter.calculateETA(durationSeconds)}',
                          style: const TextStyle(
                            color: Color(0xFF666680),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${DistanceFormatter.formatDistance(distanceMeters)}  •  $destinationName',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF999EB5),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Botón de parar — círculo rojo Waze
              GestureDetector(
                onTap: onStopNavigation,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF3B30),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF3B30).withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
