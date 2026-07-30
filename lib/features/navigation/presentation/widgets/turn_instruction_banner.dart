import 'package:flutter/material.dart';
import '../../../../core/services/mapbox_directions_service.dart';
import '../../../../core/utils/distance_formatter.dart';

class TurnInstructionBanner extends StatelessWidget {
  final RouteStep? currentStep;

  const TurnInstructionBanner({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    if (currentStep == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 16,
            offset: const Offset(0, 6),
          )
        ],
        border: Border.all(color: const Color(0xFF00C8FF), width: 2),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Color(0xFF00C8FF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getManeuverIcon(currentStep!.modifier, currentStep!.type),
              color: Colors.black,
              size: 32,
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
                    color: Color(0xFF00C8FF),
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
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
