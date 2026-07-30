import 'package:flutter/material.dart';

class LeaderboardUser {
  final int rank;
  final String name;
  final int points;
  final String badge;
  final String city;

  LeaderboardUser({
    required this.rank,
    required this.name,
    required this.points,
    required this.badge,
    required this.city,
  });
}

class LeaderboardModal extends StatelessWidget {
  final int currentPulsePoints;

  const LeaderboardModal({super.key, required this.currentPulsePoints});

  @override
  Widget build(BuildContext context) {
    final List<LeaderboardUser> topDrivers = [
      LeaderboardUser(rank: 1, name: 'Mateo G.', points: 1450, badge: '🥇 Guardián Supremo', city: 'Medellín'),
      LeaderboardUser(rank: 2, name: 'Carolina R.', points: 1210, badge: '🥈 Cazadora de Cráteres', city: 'Envigado'),
      LeaderboardUser(rank: 3, name: 'Santiago V.', points: 980, badge: '🥉 Alerta Tránsito', city: 'Sabaneta'),
      LeaderboardUser(rank: 4, name: 'Tú (Usuario WayPulse)', points: currentPulsePoints, badge: '⚡ Conductor Pulso', city: 'Valle de Aburrá'),
      LeaderboardUser(rank: 5, name: 'Alejandro M.', points: 115, badge: '🚗 Navegante Activo', city: 'Itagüí'),
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.emoji_events_rounded, color: Color(0xFFF59E0B), size: 28),
              SizedBox(width: 8),
              Text(
                'RANKING DE GUARDIANES',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Conductores destacados del Valle de Aburrá en la comunidad WayPulse',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 20),

          // Lista de posiciones
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: topDrivers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = topDrivers[index];
                final isMe = item.rank == 4;

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isMe ? const Color(0xFF1E293B) : const Color(0xFF1E293B).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: isMe ? Border.all(color: const Color(0xFF00E5FF), width: 1.5) : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: item.rank == 1
                              ? const Color(0xFFF59E0B)
                              : item.rank == 2
                                  ? const Color(0xFF94A3B8)
                                  : item.rank == 3
                                      ? const Color(0xFFB45309)
                                      : const Color(0xFF334155),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '#${item.rank}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isMe ? const Color(0xFF00E5FF) : Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${item.badge} • ${item.city}',
                              style: const TextStyle(color: Colors.white54, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.bolt_rounded, color: Color(0xFFF59E0B), size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '${item.points} pts',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF59E0B),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
