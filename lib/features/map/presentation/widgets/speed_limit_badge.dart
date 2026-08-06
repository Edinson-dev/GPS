import 'dart:ui';
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
    final bool isNearLimit = !isSpeeding && (speedLimitKmh - currentSpeedKmh <= 5) && currentSpeedKmh > 0;

    final Color badgeColor = isSpeeding
        ? const Color(0xFFFF1744)
        : isNearLimit
            ? const Color(0xFFFF9100)
            : const Color(0xFF00E676);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Velocímetro Actual Cyberpunk Glassmorphism
        ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0F172A).withValues(alpha: 0.82),
                border: Border.all(
                  color: badgeColor,
                  width: 3.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: badgeColor.withValues(alpha: 0.6),
                    blurRadius: 18,
                    spreadRadius: 3,
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    currentSpeedKmh.round().toString(),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: badgeColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Text(
                    'km/h',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Límite de Velocidad (Señal Oficial Colombiana)
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: const Color(0xFFDC2626), width: 3.5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 8,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: Center(
            child: Text(
              speedLimitKmh.round().toString(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
