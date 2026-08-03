import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import '../../features/incidents/models/medellin_closure_model.dart';

class MedellinClosuresService {
  final Dio _dio;

  static const String _baseUrl =
      'https://www.medellin.gov.co/servidormapas/rest/services/transporte/VM_Cierres_Movilidad/MapServer';

  MedellinClosuresService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 12),
                receiveTimeout: const Duration(seconds: 12),
              ),
            );

  /// Obtiene todos los cierres y desvíos reportados por la Alcaldía de Medellín
  Future<List<MedellinClosure>> fetchAllClosures() async {
    final List<MedellinClosure> allClosures = [];

    final layersConfig = [
      {'id': 0, 'category': MedellinClosureCategory.live, 'defaultTitle': 'Cierre en Vivo'},
      {'id': 3, 'category': MedellinClosureCategory.constructionTotal, 'defaultTitle': 'Obra con Cierre Total'},
      {'id': 4, 'category': MedellinClosureCategory.constructionPartial, 'defaultTitle': 'Obra con Cierre Parcial'},
      {'id': 5, 'category': MedellinClosureCategory.detour, 'defaultTitle': 'Desvío por Obra'},
      {'id': 7, 'category': MedellinClosureCategory.event, 'defaultTitle': 'Punto de Evento'},
      {'id': 8, 'category': MedellinClosureCategory.event, 'defaultTitle': 'Cierre por Evento'},
      {'id': 9, 'category': MedellinClosureCategory.detour, 'defaultTitle': 'Desvío por Evento'},
    ];

    await Future.wait(
      layersConfig.map((config) async {
        try {
          final layerId = config['id'] as int;
          final category = config['category'] as MedellinClosureCategory;
          final defaultTitle = config['defaultTitle'] as String;

          final closures = await _fetchLayerData(layerId, category, defaultTitle);
          allClosures.addAll(closures);
        } catch (_) {
          // Ignorar fallos individuales de capa para no bloquear las demás
        }
      }),
    );

    return allClosures;
  }

  Future<List<MedellinClosure>> _fetchLayerData(
    int layerId,
    MedellinClosureCategory category,
    String defaultTitle,
  ) async {
    final url = '$_baseUrl/$layerId/query?where=1%3D1&outFields=*&f=geojson&outSR=4326';
    final response = await _dio.get(url);

    if (response.statusCode != 200 || response.data == null) {
      return [];
    }

    final Map<String, dynamic> geojson =
        response.data is Map ? Map<String, dynamic>.from(response.data as Map) : {};

    final features = geojson['features'] as List<dynamic>? ?? [];
    final List<MedellinClosure> list = [];

    for (int i = 0; i < features.length; i++) {
      final feature = features[i] as Map<String, dynamic>?;
      if (feature == null) continue;

      final geometry = feature['geometry'] as Map<String, dynamic>?;
      final props = feature['properties'] as Map<String, dynamic>? ?? {};

      if (geometry == null) continue;

      final type = geometry['type'] as String?;
      final coords = geometry['coordinates'];

      List<List<LatLng>> polylines = [];
      LatLng? point;

      if (type == 'LineString' && coords is List) {
        final List<LatLng> line = [];
        for (var c in coords) {
          if (c is List && c.length >= 2) {
            final double lng = (c[0] as num).toDouble();
            final double lat = (c[1] as num).toDouble();
            line.add(LatLng(lat, lng));
          }
        }
        if (line.isNotEmpty) polylines.add(line);
      } else if (type == 'MultiLineString' && coords is List) {
        for (var lineCoords in coords) {
          if (lineCoords is List) {
            final List<LatLng> line = [];
            for (var c in lineCoords) {
              if (c is List && c.length >= 2) {
                final double lng = (c[0] as num).toDouble();
                final double lat = (c[1] as num).toDouble();
                line.add(LatLng(lat, lng));
              }
            }
            if (line.isNotEmpty) polylines.add(line);
          }
        }
      } else if (type == 'Point' && coords is List && coords.length >= 2) {
        final double lng = (coords[0] as num).toDouble();
        final double lat = (coords[1] as num).toDouble();
        point = LatLng(lat, lng);
      }

      if (polylines.isEmpty && point == null) continue;

      // Extraer títulos e información de las propiedades GeoJSON
      final String title = props['NOMBRE'] ??
          props['NOM_EVENTO'] ??
          props['OBRA'] ??
          props['MOTIVO'] ??
          props['TITULO'] ??
          defaultTitle;

      final String desc = props['DESCRIPCION'] ??
          props['OBSERVACION'] ??
          props['DETALLE'] ??
          props['HORARIO'] ??
          'Reportado por la Secretaría de Movilidad de Medellín';

      final String id = 'med_${layerId}_${props['OBJECTID'] ?? props['FID'] ?? i}';

      list.add(
        MedellinClosure(
          id: id,
          title: title.toString(),
          category: category,
          description: desc.toString(),
          polylines: polylines,
          point: point,
        ),
      );
    }

    return list;
  }
}
