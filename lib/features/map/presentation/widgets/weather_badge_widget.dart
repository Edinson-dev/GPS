import 'package:flutter/material.dart';

class WeatherBadgeWidget extends StatelessWidget {
  final String condition;
  final int tempCelsius;
  final String statusText;

  const WeatherBadgeWidget({
    super.key,
    this.condition = '⛅ Sol Parcial',
    this.tempCelsius = 24,
    this.statusText = 'Vía Seca • Óptima',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 10,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wb_sunny_rounded, color: Color(0xFFF59E0B), size: 16),
          const SizedBox(width: 6),
          Text(
            '$tempCelsius°C',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 6),
          Container(width: 1, height: 12, color: Colors.white24),
          const SizedBox(width: 6),
          Text(
            statusText,
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
