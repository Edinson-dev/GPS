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
      {
        'name': 'Waze Día',
        'icon': Icons.wb_sunny_rounded,
        'desc': 'Mapa claro antideslumbrante',
        'color': const Color(0xFF1B4FD8),
      },
      {
        'name': 'Modo Noche',
        'icon': Icons.nightlight_round,
        'desc': 'Fondo oscuro para la noche',
        'color': const Color(0xFF8B5CF6),
      },
      {
        'name': 'Satélite HD',
        'icon': Icons.satellite_alt_rounded,
        'desc': 'Fotografía aérea real',
        'color': const Color(0xFF10B981),
      },
      {
        'name': 'Tráfico 3D',
        'icon': Icons.traffic_rounded,
        'desc': 'Flujo vehicular en vivo',
        'color': const Color(0xFFFF3B30),
      },
      {
        'name': 'OLED / Ahorro',
        'icon': Icons.battery_saver_rounded,
        'desc': 'Negro puro para ruta larga',
        'color': const Color(0xFF333355),
      },
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFDDDDE8),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Text(
            'Estilo del mapa',
            style: TextStyle(
              color: Color(0xFF1A1A2E),
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
              mainAxisExtent: 76,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
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
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? color.withValues(alpha: 0.08) : const Color(0xFFF8F8FC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? color : const Color(0xFFE5E5F0),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        st['icon'] as IconData,
                        color: isSelected ? color : const Color(0xFF666680),
                        size: 26,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              st['name'] as String,
                              style: TextStyle(
                                color: isSelected ? color : const Color(0xFF1A1A2E),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              st['desc'] as String,
                              style: const TextStyle(
                                color: Color(0xFF999EB5),
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
