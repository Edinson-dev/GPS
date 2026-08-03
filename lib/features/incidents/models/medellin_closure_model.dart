import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

enum MedellinClosureCategory {
  live,
  constructionTotal,
  constructionPartial,
  event,
  detour,
}

class MedellinClosure {
  final String id;
  final String title;
  final MedellinClosureCategory category;
  final String description;
  final List<List<LatLng>> polylines;
  final LatLng? point;

  MedellinClosure({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.polylines,
    this.point,
  });

  String get categoryLabel {
    switch (category) {
      case MedellinClosureCategory.live:
        return 'Cierre en Vivo';
      case MedellinClosureCategory.constructionTotal:
        return 'Cierre Total por Obra';
      case MedellinClosureCategory.constructionPartial:
        return 'Cierre Parcial por Obra';
      case MedellinClosureCategory.event:
        return 'Cierre por Evento';
      case MedellinClosureCategory.detour:
        return 'Ruta de Desvío';
    }
  }

  Color get color {
    switch (category) {
      case MedellinClosureCategory.live:
        return const Color(0xFFFF1744); // Rojo Neón Vivo
      case MedellinClosureCategory.constructionTotal:
        return const Color(0xFFFF5252); // Rojo Naranja Obra Total
      case MedellinClosureCategory.constructionPartial:
        return const Color(0xFFFF9100); // Naranja Neón Obra Parcial
      case MedellinClosureCategory.event:
        return const Color(0xFFD500F9); // Púrpura Eventos
      case MedellinClosureCategory.detour:
        return const Color(0xFF00E676); // Verde Neón Desvíos
    }
  }

  IconData get icon {
    switch (category) {
      case MedellinClosureCategory.live:
        return Icons.do_not_disturb_on_rounded;
      case MedellinClosureCategory.constructionTotal:
        return Icons.engineering_rounded;
      case MedellinClosureCategory.constructionPartial:
        return Icons.construction_rounded;
      case MedellinClosureCategory.event:
        return Icons.event_available_rounded;
      case MedellinClosureCategory.detour:
        return Icons.alt_route_rounded;
    }
  }
}
