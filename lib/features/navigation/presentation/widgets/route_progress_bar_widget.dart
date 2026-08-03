import 'package:flutter/material.dart';
import '../../../../core/services/mapbox_directions_service.dart';

class RouteProgressBarWidget extends StatelessWidget {
  final MapboxRoute route;
  final int currentStepIndex;
  final double currentSpeedKmh;

  const RouteProgressBarWidget({
    super.key,
    required this.route,
    required this.currentStepIndex,
    required this.currentSpeedKmh,
  });

  @override
  Widget build(BuildContext context) {
    final totalSteps = route.steps.length;
    final progressRatio = totalSteps > 0 ? (currentStepIndex / totalSteps).clamp(0.0, 1.0) : 0.0;

    return Container(
      width: 24,
      height: 220,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00C8FF).withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 6),
          const Icon(Icons.flag_rounded, color: Color(0xFFFF2E55), size: 14),
          const SizedBox(height: 4),
          Expanded(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Línea base de ruta
                Container(
                  width: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFF334155),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                // Progreso recorrido iluminado verde
                FractionallySizedBox(
                  heightFactor: progressRatio,
                  child: Container(
                    width: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10B981).withValues(alpha: 0.6),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
                // Indicador de posición actual del vehículo en la barra
                Positioned(
                  bottom: (progressRatio * 180).clamp(0.0, 180.0),
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: currentSpeedKmh > 80 ? const Color(0xFFFF2E55) : const Color(0xFF00C8FF),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: (currentSpeedKmh > 80 ? const Color(0xFFFF2E55) : const Color(0xFF00C8FF))
                              .withValues(alpha: 0.8),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const Icon(Icons.navigation_rounded, color: Color(0xFF00C8FF), size: 14),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}
