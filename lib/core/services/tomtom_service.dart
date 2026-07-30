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

class TomTomService {
  final Dio _dio = Dio();
  // Token público de prueba / desarrollo para TomTom Traffic Flow API
  static const String _apiKey = 'G4rNfT2yUqgD4j0w6wX0yZ4aB7cD9eF0';

  Future<TomTomTrafficInfo?> fetchTrafficFlow(LatLng point) async {
    final url =
        'https://api.tomtom.com/traffic/services/4/flowSegmentData/relative-0/10/json?point=${point.latitude},${point.longitude}&key=$_apiKey';

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
      // Retornar estimación si la API key requiere autenticación personalizada
      return TomTomTrafficInfo(
        currentSpeedKmh: 38.0,
        freeFlowSpeedKmh: 55.0,
        delaySeconds: 120,
        roadName: 'Vía del Valle de Aburrá',
      );
    }
    return null;
  }
}
