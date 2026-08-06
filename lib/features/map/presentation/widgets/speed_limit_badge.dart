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
    final bool isNearLimit =
        !isSpeeding && (speedLimitKmh - currentSpeedKmh <= 5) && currentSpeedKmh > 0;

    // Colores de velocímetro estilo Waze (blanco con acento de color)
    final Color speedColor = isSpeeding
        ? const Color(0xFFFF3B30)
        : isNearLimit
            ? const Color(0xFFFF9500)
            : const Color(0xFF1A1A2E);

    final Color borderColor = isSpeeding
        ? const Color(0xFFFF3B30)
        : isNearLimit
            ? const Color(0xFFFF9500)
            : const Color(0xFFDDDDE8);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Velocímetro actual — Blanco con borde de color Waze
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSpeeding ? const Color(0xFFFF3B30) : Colors.white,
            border: Border.all(
              color: borderColor,
              width: 3.0,
            ),
            boxShadow: [
              BoxShadow(
                color: borderColor.withValues(alpha: isSpeeding ? 0.5 : 0.25),
                blurRadius: 14,
                spreadRadius: 2,
              ),
              const BoxShadow(
                color: Color(0x33000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                currentSpeedKmh.round().toString(),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: isSpeeding ? Colors.white : speedColor,
                  letterSpacing: -0.5,
                  height: 1.0,
                ),
              ),
              Text(
                'km/h',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isSpeeding
                      ? Colors.white70
                      : const Color(0xFF999EB5),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        // Límite de velocidad — señal colombiana (círculo rojo)
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: const Color(0xFFDC2626), width: 3.5),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              speedLimitKmh.round().toString(),
              style: const TextStyle(
                fontSize: 14,
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
