import 'package:flutter/material.dart';
import '../../../../core/services/pico_placa_service.dart';

class PicoPlacaBadge extends StatelessWidget {
  final PicoPlacaResult result;

  const PicoPlacaBadge({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final isRestricted = result.isRestricted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isRestricted ? const Color(0xFF7F1D1D) : const Color(0xFF065F46),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRestricted ? const Color(0xFFEF4444) : const Color(0xFF10B981),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (isRestricted ? Colors.red : Colors.green).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(
            isRestricted ? Icons.warning_rounded : Icons.check_circle_rounded,
            color: Colors.white,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isRestricted
                      ? '🚨 PICO Y PLACA ACTIVO EN ${result.cityName.toUpperCase()}'
                      : '🟢 LIBRE DE PICO Y PLACA EN ${result.cityName.toUpperCase()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  result.timeWindow,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
