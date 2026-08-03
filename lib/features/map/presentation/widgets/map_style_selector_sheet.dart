import 'package:flutter/material.dart';

class MapStyleSelectorSheet extends StatelessWidget {
  final int currentStyleIndex;
  final Function(int index) onSelectStyle;

  const MapStyleSelectorSheet({
    super.key,
    required this.currentStyleIndex,
    required this.onSelectStyle,
  });

  @override
  Widget build(BuildContext context) {
    final styles = [
      {'name': 'Waze Día', 'icon': Icons.wb_sunny_rounded, 'desc': 'Antideslumbrante ligero', 'color': const Color(0xFF00C8FF)},
      {'name': 'Cyberpunk Noche', 'icon': Icons.nightlight_round, 'desc': 'Fondo oscuro neón', 'color': const Color(0xFF8B5CF6)},
      {'name': 'Satélite HD', 'icon': Icons.satellite_alt_rounded, 'desc': 'Fotografía aérea real', 'color': const Color(0xFF10B981)},
      {'name': 'Tráfico 3D', 'icon': Icons.traffic_rounded, 'desc': 'Flujo vehicular en vivo', 'color': const Color(0xFFFF2E55)},
      {'name': 'OLED Ahorro Batería', 'icon': Icons.battery_saver_rounded, 'desc': 'Negro puro para ruta larga', 'color': const Color(0xFF10B981)},
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: const Color(0xFF00C8FF).withValues(alpha: 0.4)),
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
                color: Colors.white30,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Estilo y Capa del Mapa',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 80,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: styles.length,
            itemBuilder: (context, idx) {
              final isSelected = currentStyleIndex == idx;
              final st = styles[idx];
              final color = st['color'] as Color;

              return InkWell(
                onTap: () {
                  onSelectStyle(idx);
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? color.withValues(alpha: 0.25) : const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? color : Colors.white12,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(st['icon'] as IconData, color: isSelected ? color : Colors.white70, size: 28),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              st['name'] as String,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              st['desc'] as String,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 10,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
