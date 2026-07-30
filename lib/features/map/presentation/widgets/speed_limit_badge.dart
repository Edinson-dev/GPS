import 'package:flutter/material.dart';

class SpeedLimitBadge extends StatelessWidget {
  final double currentSpeedKmh;
  final double speedLimitKmh;

  const SpeedLimitBadge({
    super.key,
    required this.currentSpeedKmh,
    required this.speedLimitKmh,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSpeeding = currentSpeedKmh > speedLimitKmh;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Velocímetro Actual
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSpeeding ? const Color(0xFFFF2E55) : const Color(0xFF1E293B),
            border: Border.all(
              color: isSpeeding ? Colors.white : const Color(0xFF00C8FF),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: (isSpeeding ? const Color(0xFFFF2E55) : const Color(0xFF00C8FF))
                    .withOpacity(0.4),
                blurRadius: 12,
                spreadRadius: 2,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                currentSpeedKmh.round().toString(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const Text(
                'km/h',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        // Límite de Velocidad (Señal Circular)
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Colors.red, width: 3),
          ),
          child: Center(
            child: Text(
              speedLimitKmh.round().toString(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
