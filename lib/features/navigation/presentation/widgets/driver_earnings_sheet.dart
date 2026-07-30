import 'package:flutter/material.dart';

class DriverEarningsSheet extends StatefulWidget {
  final double distanceKm;
  final double durationMinutes;
  final int tollsCop;

  const DriverEarningsSheet({
    super.key,
    required this.distanceKm,
    required this.durationMinutes,
    required this.tollsCop,
  });

  @override
  State<DriverEarningsSheet> createState() => _DriverEarningsSheetState();
}

class _DriverEarningsSheetState extends State<DriverEarningsSheet> {
  // Parámetros promedio de combustible en Colombia (COP $)
  static const double gasPricePerGallon = 15800; // $15.800 COP/galón promedio
  static const double kmPerGallonAuto = 38.0; // 38 km/galón
  static const double kmPerGallonMoto = 110.0; // 110 km/galón

  bool isMoto = false;

  @override
  Widget build(BuildContext context) {
    final kmPerGallon = isMoto ? kmPerGallonMoto : kmPerGallonAuto;
    final gallonsNeeded = widget.distanceKm / kmPerGallon;
    final fuelCostCop = (gallonsNeeded * gasPricePerGallon).round();

    // Cálculo tarifa recomendada para conductores (Base $4.500 + $1.200/km + $250/min + Peajes)
    const baseFare = 4500.0;
    final kmFare = widget.distanceKm * 1200.0;
    final minFare = widget.durationMinutes * 250.0;
    final totalRecommendedFare = (baseFare + kmFare + minFare + widget.tollsCop).round();

    final netProfit = totalRecommendedFare - fuelCostCop - widget.tollsCop;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF111827),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.attach_money_rounded, color: Color(0xFF10B981), size: 26),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calculadora para Conductores',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'Estimación de combustible & tarifa justa (Uber / InDrive)',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Selector Tipo Vehículo (Auto vs Moto)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isMoto = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: !isMoto ? const Color(0xFF00E5FF) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          '🚗 Automóvil',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: !isMoto ? Colors.black : Colors.white60,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isMoto = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isMoto ? const Color(0xFF00E5FF) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          '🏍️ Motocicleta',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isMoto ? Colors.black : Colors.white60,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Tarjetas de Métricas (Gasolina, Peajes, Tarifa Sugerida)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Gasolina Estimada:', style: TextStyle(color: Colors.white70)),
                    Text(
                      '\$${fuelCostCop.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')} COP',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFEF4444)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Peajes en Ruta:', style: TextStyle(color: Colors.white70)),
                    Text(
                      '\$${widget.tollsCop.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')} COP',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF59E0B)),
                    ),
                  ],
                ),
                const Divider(color: Colors.white12, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tarifa Sugerida Viaje:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      '\$${totalRecommendedFare.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')} COP',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Ganancia Neta Estimada:', style: TextStyle(color: Colors.white54, fontSize: 12)),
                    Text(
                      '\$${netProfit.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')} COP',
                      style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
