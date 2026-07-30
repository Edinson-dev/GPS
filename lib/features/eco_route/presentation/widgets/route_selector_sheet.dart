import 'package:flutter/material.dart';
import '../../../../core/services/mapbox_directions_service.dart';
import '../../../../core/utils/distance_formatter.dart';

class RouteSelectorSheet extends StatelessWidget {
  final List<MapboxRoute> routes;
  final MapboxRoute? selectedRoute;
  final Function(MapboxRoute route) onSelect;
  final VoidCallback onStartNavigation;

  const RouteSelectorSheet({
    super.key,
    required this.routes,
    required this.selectedRoute,
    required this.onSelect,
    required this.onStartNavigation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
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
          const Text(
            'Elige tu Ruta',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: routes.length,
            itemBuilder: (context, index) {
              final r = routes[index];
              final isSelected = selectedRoute?.id == r.id;

              return InkWell(
                onTap: () => onSelect(r),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF00C8FF).withOpacity(0.15)
                        : const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF00C8FF)
                          : const Color(0xFF334155),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        r.isEcoFriendly
                            ? Icons.eco_rounded
                            : Icons.bolt_rounded,
                        color: r.isEcoFriendly
                            ? const Color(0xFF00E676)
                            : const Color(0xFFFF6B00),
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  r.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                if (r.isEcoFriendly) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF00E676).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'ECO',
                                      style: TextStyle(
                                        color: Color(0xFF00E676),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ]
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${DistanceFormatter.formatDuration(r.durationSeconds)} • ${DistanceFormatter.formatDistance(r.distanceMeters)}',
                              style: const TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'ETA ${DistanceFormatter.calculateETA(r.durationSeconds)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onStartNavigation,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C8FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: const Text(
                'IR AHORA (MODO NAVEGACIÓN)',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
