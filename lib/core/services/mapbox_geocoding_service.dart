import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import '../constants/mapbox_constants.dart';
import '../constants/colombia_poi_database.dart';

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

  String _normalizeColombianAddress(String input) {
    String s = input.trim();

    // 1. Reemplazar prefijos de vías principales
    s = s
        .replaceAll(RegExp(r'\bcra\.?\b', caseSensitive: false), 'Carrera ')
        .replaceAll(RegExp(r'\bcll\.?\b', caseSensitive: false), 'Calle ')
        .replaceAll(RegExp(r'\btv\.?\b', caseSensitive: false), 'Transversal ')
        .replaceAll(RegExp(r'\bdg\.?\b', caseSensitive: false), 'Diagonal ')
        .replaceAll(RegExp(r'\bav\.?\b', caseSensitive: false), 'Avenida ')
        .replaceAll(RegExp(r'\bauto\.?\b', caseSensitive: false), 'Autopista ');

    // 2. Unir número con letra separada (ej: "71 c" -> "71C", "89 a" -> "89A")
    s = s.replaceAllMapped(
      RegExp(r'(\d+)\s+([a-zA-Z])(?=\s|\#|\-|$|\d)', caseSensitive: false),
      (match) => '${match.group(1)}${match.group(2)?.toUpperCase()}',
    );

    // 3. Normalizar espacios alrededor del numeral #
    s = s.replaceAll(RegExp(r'\#\s+'), '#');

    // 4. Formatear la placa (ej: "#89A 13" o "# 89A - 13" -> "#89A-13")
    s = s.replaceAllMapped(
      RegExp(r'(\#\w+)\s*[\-\s]\s*(\d+)', caseSensitive: false),
      (match) => '${match.group(1)}-${match.group(2)}',
    );

    return s;
  }

  Future<List<SearchLocationResult>> searchPlaces(
    String query, {
    LatLng? proximity,
  }) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    // Búsqueda en la Base de Datos Local de Puntos Clave de Colombia & Valle de Aburrá
    final localPois = ColombiaPoiDatabase.searchLocalPois(trimmed);
    final List<SearchLocationResult> results = localPois
        .map(
          (poi) => SearchLocationResult(
            id: 'local_${poi.title.hashCode}',
            title: poi.title,
            address: poi.address,
            position: poi.position,
          ),
        )
        .toList();

    // Formatear dirección colombiana (ej: "cra 71 c # 89 a 13" -> "Carrera 71C #89A-13")
    final expandedQuery = _normalizeColombianAddress(trimmed);

    // Ubicación de referencia para anclar proximidad (Medellín / Colombia)
    final effectiveProximity = proximity ?? const LatLng(6.2494, -75.5681);

    final url = '${MapboxConstants.geocodingBaseUrl}/${Uri.encodeComponent(expandedQuery)}.json';
    final queryParams = {
      'access_token': MapboxConstants.publicToken,
      'autocomplete': 'true',
      'limit': '10',
      'language': 'es',
      'country': 'co', // Restringir a Colombia
      'proximity': '${effectiveProximity.longitude},${effectiveProximity.latitude}',
    };

    try {
      final response = await _dio.get(url, queryParameters: queryParams);

      if (response.statusCode == 200 && response.data['features'] != null) {
        final features = response.data['features'] as List;
        final List<SearchLocationResult> onlineResults = features.map((f) {
          final center = f['center'] as List;
          String rawAddress = f['place_name'] ?? f['text'] ?? '';

          // Eliminar cualquier código postal (ej: ", 050021", ", 110111", "CP 12345")
          final cleanAddress = rawAddress
              .replaceAll(RegExp(r',\s*\b\d{5,6}\b'), '')
              .replaceAll(RegExp(r'\bCP\s*\d{5,6}\b', caseSensitive: false), '')
              .trim();

          return SearchLocationResult(
            id: f['id'] ?? '',
            title: f['text'] ?? f['place_name'] ?? 'Ubicación Exacta',
            address: cleanAddress.isNotEmpty ? cleanAddress : rawAddress,
            position: LatLng(
              (center[1] as num).toDouble(),
              (center[0] as num).toDouble(),
            ),
          );
        }).toList();

        // Ordenar los resultados online por cercanía a la ubicación actual / Medellín
        const distance = Distance();
        onlineResults.sort((a, b) {
          final distA = distance.as(LengthUnit.Meter, effectiveProximity, a.position);
          final distB = distance.as(LengthUnit.Meter, effectiveProximity, b.position);
          return distA.compareTo(distB);
        });

        results.addAll(onlineResults);
        return results;
      }
    } catch (e) {
      return results;
    }
    return results;
  }
}
