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
        // Banner Principal TomTom GO (Azul Oscuro / Azul Eléctrico)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF1E40AF),
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(24),
              bottom: nextStep != null ? Radius.zero : const Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getManeuverIcon(currentStep!.modifier, currentStep!.type),
                  color: const Color(0xFF1E40AF),
                  size: 34,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DistanceFormatter.formatDistance(currentStep!.distanceMeters),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      currentStep!.instruction,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Sub-Banner TomTom "Luego en X m [Maniobra]"
        if (nextStep != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF3B82F6),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Luego en ${DistanceFormatter.formatDistance(nextStep!.distanceMeters)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  _getManeuverIcon(nextStep!.modifier, nextStep!.type),
                  color: Colors.white,
                  size: 20,
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
