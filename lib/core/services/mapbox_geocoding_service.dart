import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import '../constants/mapbox_constants.dart';

class SearchLocationResult {
  final String id;
  final String title;
  final String address;
  final LatLng position;

  SearchLocationResult({
    required this.id,
    required this.title,
    required this.address,
    required this.position,
  });
}

class MapboxGeocodingService {
  final Dio _dio = Dio();

  Future<List<SearchLocationResult>> searchPlaces(
    String query, {
    LatLng? proximity,
  }) async {
    if (query.trim().isEmpty) return [];

    final url = '${MapboxConstants.geocodingBaseUrl}/${Uri.encodeComponent(query)}.json';
    final queryParams = {
      'access_token': MapboxConstants.publicToken,
      'autocomplete': 'true',
      'limit': '5',
      'language': 'es',
    };

    if (proximity != null) {
      queryParams['proximity'] = '${proximity.longitude},${proximity.latitude}';
    }

    try {
      final response = await _dio.get(url, queryParameters: queryParams);

      if (response.statusCode == 200 && response.data['features'] != null) {
        final features = response.data['features'] as List;
        return features.map((f) {
          final center = f['center'] as List;
          return SearchLocationResult(
            id: f['id'] ?? '',
            title: f['text'] ?? f['place_name'] ?? 'Ubicación',
            address: f['place_name'] ?? '',
            position: LatLng(
              (center[1] as num).toDouble(),
              (center[0] as num).toDouble(),
            ),
          );
        }).toList();
      }
    } catch (e) {
      return [];
    }
    return [];
  }
}
