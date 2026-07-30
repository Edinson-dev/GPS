import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import '../constants/speed_camera_database.dart';

class SpeedCameraApiService {
  final Dio _dio = Dio();

  // API 1: Datos Abiertos del Gobierno de Colombia (Cámaras de Fotodetección Autorizadas ANSV / Mintransporte)
  static const String _govDataUrl =
      'https://www.datos.gov.co/resource/cámaras-fotodetección-colombia.json';

  // API 2: Overpass API OpenStreetMap (Consulta pública de radares de velocidad por bounding box)
  static const String _overpassUrl = 'https://overpass-api.de/api/interpreter';

  Future<List<SpeedCameraItem>> fetchLiveSpeedCameras({
    double minLng = -75.7,
    double minLat = 6.0,
    double maxLng = -75.4,
    double maxLat = 6.4,
  }) async {
    final List<SpeedCameraItem> cameras = [];

    // 1. Cargar cámaras locales de respaldo
    cameras.addAll(SpeedCameraDatabase.cameras);

    // 2. Consultar API de Overpass OpenStreetMap para cámaras en tiempo real en la región
    try {
      final overpassQuery =
          '[out:json][timeout:10];node["highway"="speed_camera"]($minLat,$minLng,$maxLat,$maxLng);out body;';
      final response = await _dio.get(
        _overpassUrl,
        queryParameters: {'data': overpassQuery},
        options: Options(responseType: ResponseType.json),
      );

      if (response.statusCode == 200 && response.data != null && response.data['elements'] != null) {
        final elements = response.data['elements'] as List;
        for (final el in elements) {
          final lat = (el['lat'] as num?)?.toDouble();
          final lon = (el['lon'] as num?)?.toDouble();
          final tags = (el['tags'] as Map?) ?? {};
          final maxSpeed = int.tryParse(tags['maxspeed']?.toString() ?? '60') ?? 60;

          if (lat != null && lon != null) {
            final id = 'overpass_${el['id']}';
            // Evitar duplicados si ya existe una cámara cercana
            final exists = cameras.any((c) => (c.position.latitude - lat).abs() < 0.001 && (c.position.longitude - lon).abs() < 0.001);
            if (!exists) {
              cameras.add(
                SpeedCameraItem(
                  id: id,
                  locationName: tags['description'] ?? tags['name'] ?? 'Cámara de Fotomulta (Límite $maxSpeed km/h)',
                  maxSpeedKmh: maxSpeed,
                  position: LatLng(lat, lon),
                  type: 'velocidad',
                ),
              );
            }
          }
        }
      }
    } catch (_) {}

    // 3. Consultar API Datos Abiertos Colombia (datos.gov.co)
    try {
      final response = await _dio.get(
        _govDataUrl,
        queryParameters: {r'$limit': '50'},
      );

      if (response.statusCode == 200 && response.data is List) {
        final list = response.data as List;
        for (final item in list) {
          if (item is Map) {
            final lat = double.tryParse(item['latitud']?.toString() ?? '');
            final lon = double.tryParse(item['longitud']?.toString() ?? '');
            final mun = item['municipio']?.toString() ?? 'Colombia';
            final dir = item['direccion']?.toString() ?? 'Vía Principal';
            final speed = int.tryParse(item['velocidad_permitida']?.toString() ?? '60') ?? 60;

            if (lat != null && lon != null) {
              final id = 'gov_${item['id'] ?? lat.hashCode}';
              final exists = cameras.any((c) => (c.position.latitude - lat).abs() < 0.001 && (c.position.longitude - lon).abs() < 0.001);
              if (!exists) {
                cameras.add(
                  SpeedCameraItem(
                    id: id,
                    locationName: 'Fotomulta ANSV ($mun - $dir)',
                    maxSpeedKmh: speed,
                    position: LatLng(lat, lon),
                    type: 'fija',
                  ),
                );
              }
            }
          }
        }
      }
    } catch (_) {}

    return cameras;
  }
}
