import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

class TomTomTrafficInfo {
  final double currentSpeedKmh;
  final double freeFlowSpeedKmh;
  final int delaySeconds;
  final String roadName;

  TomTomTrafficInfo({
    required this.currentSpeedKmh,
    required this.freeFlowSpeedKmh,
    required this.delaySeconds,
    required this.roadName,
  });
}

class TomTomIncident {
  final String id;
  final String description;
  final LatLng location;
  final String category;
  final int delaySeconds;

  TomTomIncident({
    required this.id,
    required this.description,
    required this.location,
    required this.category,
    required this.delaySeconds,
  });
}

class TomTomService {
  final Dio _dio = Dio();
  // Key oficial de TomTom del proyecto Edinson's Personal Project
  static const String apiKey = 'oF10QbV86fc3I2rh8EZTMOXaTZNIBd5p';

  Future<TomTomTrafficInfo?> fetchTrafficFlow(LatLng point) async {
    final url =
        'https://api.tomtom.com/traffic/services/4/flowSegmentData/relative-0/10/json?point=${point.latitude},${point.longitude}&key=$apiKey';

    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200 && response.data['flowSegmentData'] != null) {
        final data = response.data['flowSegmentData'];
        final currentSpeed = (data['currentSpeed'] as num?)?.toDouble() ?? 45.0;
        final freeFlowSpeed = (data['freeFlowSpeed'] as num?)?.toDouble() ?? 50.0;
        final delay = (data['currentDelay'] as num?)?.toInt() ?? 0;

        return TomTomTrafficInfo(
          currentSpeedKmh: currentSpeed,
          freeFlowSpeedKmh: freeFlowSpeed,
          delaySeconds: delay,
          roadName: data['name'] ?? 'Vía Principal',
        );
      }
    } catch (_) {
      return TomTomTrafficInfo(
        currentSpeedKmh: 42.0,
        freeFlowSpeedKmh: 60.0,
        delaySeconds: 0,
        roadName: 'Vía en Monitoreo TomTom',
      );
    }
    return null;
  }

  Future<List<TomTomIncident>> fetchTrafficIncidents({
    double minLng = -75.7,
    double minLat = 6.0,
    double maxLng = -75.4,
    double maxLat = 6.4,
  }) async {
    final url =
        'https://api.tomtom.com/traffic/services/5/incidentDetails?key=$apiKey&bbox=$minLng,$minLat,$maxLng,$maxLat&language=es-ES';

    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200 && response.data['incidents'] != null) {
        final rawList = response.data['incidents'] as List;
        return rawList.map((inc) {
          final props = inc['properties'] ?? {};
          final geom = inc['geometry'] ?? {};
          final coords = (geom['coordinates'] as List?) ?? [[-75.5681, 6.2494]];
          final firstCoord = coords.first is List ? coords.first as List : coords;

          final events = (props['events'] as List?) ?? [];
          final desc = events.isNotEmpty
              ? events.first['description'] ?? 'Incidente vial'
              : 'Tráfico lento / Obra en vía';

          return TomTomIncident(
            id: inc['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
            description: desc,
            location: LatLng(
              (firstCoord[1] as num).toDouble(),
              (firstCoord[0] as num).toDouble(),
            ),
            category: props['iconCategory']?.toString() ?? 'accident',
            delaySeconds: (props['delayInSeconds'] as num?)?.toInt() ?? 0,
          );
        }).toList();
      }
    } catch (_) {
      return [];
    }
    return [];
  }
}
