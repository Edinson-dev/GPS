import 'package:flutter/material.dart';
import '../../../../core/services/mapbox_directions_service.dart';
import '../../../../core/utils/distance_formatter.dart';

class TurnInstructionBanner extends StatelessWidget {
  final RouteStep? currentStep;
  final RouteStep? nextStep;

  const TurnInstructionBanner({
    super.key,
    required this.currentStep,
    this.nextStep,
  });

  @override
  Widget build(BuildContext context) {
    if (currentStep == null) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Banner Principal — Azul Marino Waze sólido
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF1B4FD8), // Azul Waze puro
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(20),
              bottom: nextStep != null ? Radius.zero : const Radius.circular(20),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x55000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icono de maniobra en cuadro blanco redondeado
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  _getManeuverIcon(currentStep!.modifier, currentStep!.type),
                  color: Colors.white,
                  size: 38,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Distancia grande blanca
                    Text(
                      DistanceFormatter.formatDistance(
                          currentStep!.distanceMeters),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Instrucción en blanco semi-transparente
                    Text(
                      currentStep!.instruction,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Sub-Banner "Luego en..." — Azul oscuro Waze
        if (nextStep != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFF1240B0), // Azul ligeramente más oscuro
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getManeuverIcon(nextStep!.modifier, nextStep!.type),
                  color: Colors.white70,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Luego en ${DistanceFormatter.formatDistance(nextStep!.distanceMeters)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  IconData _getManeuverIcon(String modifier, String type) {
    if (modifier.contains('left')) {
      return Icons.turn_left_rounded;
    } else if (modifier.contains('right')) {
      return Icons.turn_right_rounded;
    } else if (modifier.contains('slight_left')) {
      return Icons.turn_slight_left_rounded;
    } else if (modifier.contains('slight_right')) {
      return Icons.turn_slight_right_rounded;
    } else if (type.contains('uturn')) {
      return Icons.u_turn_left_rounded;
    }
    return Icons.straight_rounded;
  }
}
