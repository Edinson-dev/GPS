import 'dart:ui';
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

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Banner Principal Cyberpunk HUD Glassmorphism
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A).withValues(alpha: 0.82),
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(24),
                  bottom: nextStep != null ? Radius.zero : const Radius.circular(24),
                ),
                border: Border.all(
                  color: const Color(0xFF00E5FF).withValues(alpha: 0.6),
                  width: 1.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00E5FF).withValues(alpha: 0.30),
                    blurRadius: 20,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00E5FF), Color(0xFF2979FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00E5FF).withValues(alpha: 0.5),
                          blurRadius: 12,
                          spreadRadius: 1,
                        )
                      ],
                    ),
                    child: Icon(
                      _getManeuverIcon(currentStep!.modifier, currentStep!.type),
                      color: Colors.white,
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
                            color: Color(0xFF00E5FF),
                            fontSize: 28,
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

            // Sub-Banner Cyberpunk "Luego en X m [Maniobra]"
            if (nextStep != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                  border: Border.all(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.5),
                    width: 1,
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
                      color: const Color(0xFF60A5FA),
                      size: 20,
                    ),
                  ],
                ),
              ),
          ],
        ),
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
