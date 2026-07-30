import 'package:latlong2/latlong.dart';

class RouteDecoder {
  /// Decodifica una geometría codificada en formato Polyline6 de Mapbox API
  static List<LatLng> decodePolyline6(String encoded) {
    List<LatLng> points = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      // Polyline6 usa precision de 1e6 (1,000,000)
      points.add(LatLng(lat / 1000000.0, lng / 1000000.0));
    }
    return points;
  }
}
