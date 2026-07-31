import 'package:flutter/material.dart';

class LaneGuidanceWidget extends StatelessWidget {
  final int totalLanes;
  final int activeLaneIndex;
  final String nextManeuverText;

  const LaneGuidanceWidget({
    super.key,
    this.totalLanes = 3,
    this.activeLaneIndex = 1,
    required this.nextManeuverText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00C8FF).withValues(alpha: 0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00C8FF).withValues(alpha: 0.25),
            blurRadius: 12,
            spreadRadius: 1,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(totalLanes, (index) {
              final bool isActive = index == activeLaneIndex;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF10B981).withValues(alpha: 0.25)
                      : Colors.white10,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isActive ? const Color(0xFF10B981) : Colors.white24,
                    width: isActive ? 2 : 1,
                  ),
                ),
                child: Icon(
                  isActive ? Icons.navigation_rounded : Icons.straight_rounded,
                  color: isActive ? const Color(0xFF10B981) : Colors.white38,
                  size: 20,
                ),
              );
            }),
          ),
          const SizedBox(height: 4),
          Text(
            nextManeuverText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
