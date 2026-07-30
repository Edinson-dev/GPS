import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

enum IncidentType {
  police,
  speedCamera,
  trafficJam,
  crash,
  hazard,
  construction,
  pothole,
  flooding,
}

class IncidentReport {
  final String id;
  final IncidentType type;
  final String title;
  final String description;
  final LatLng position;
  final DateTime timestamp;
  final int positiveVotes;
  final String reportedByUserName;

  IncidentReport({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.position,
    required this.timestamp,
    this.positiveVotes = 1,
    this.reportedByUserName = 'Conductor Pulse',
  });

  IconData get icon {
    switch (type) {
      case IncidentType.police:
        return Icons.local_police_rounded;
      case IncidentType.speedCamera:
        return Icons.camera_alt_rounded;
      case IncidentType.trafficJam:
        return Icons.traffic_rounded;
      case IncidentType.crash:
        return Icons.car_crash_rounded;
      case IncidentType.hazard:
        return Icons.warning_amber_rounded;
      case IncidentType.construction:
        return Icons.engineering_rounded;
      case IncidentType.pothole:
        return Icons.broken_image_rounded;
      case IncidentType.flooding:
        return Icons.water_drop_rounded;
    }
  }

  Color get color {
    switch (type) {
      case IncidentType.police:
        return const Color(0xFF29B6F6);
      case IncidentType.speedCamera:
        return const Color(0xFFFFB300);
      case IncidentType.trafficJam:
        return const Color(0xFFFF6B00);
      case IncidentType.crash:
        return const Color(0xFFFF2E55);
      case IncidentType.hazard:
        return const Color(0xFFFF9100);
      case IncidentType.construction:
        return const Color(0xFFAB47BC);
      case IncidentType.pothole:
        return const Color(0xFFFF5722);
      case IncidentType.flooding:
        return const Color(0xFF00B0FF);
    }
  }
}
