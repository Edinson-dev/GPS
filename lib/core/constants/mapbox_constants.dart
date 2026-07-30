class MapboxConstants {
  // Tokens configurados por el desarrollador
  static const String publicToken =
      String.fromEnvironment('MAPBOX_PUBLIC_TOKEN', defaultValue: 'YOUR_MAPBOX_PUBLIC_TOKEN');
      
  static const String secretToken =
      'YOUR_MAPBOX_SECRET_TOKEN';

  // Estilos de Mapa Oficiales de Mapbox
  static const String styleStreets = 'mapbox://styles/mapbox/streets-v12';
  static const String styleDark = 'mapbox://styles/mapbox/dark-v11';
  static const String styleLight = 'mapbox://styles/mapbox/light-v11';
  static const String styleSatellite = 'mapbox://styles/mapbox/satellite-streets-v12';
  static const String styleNavigationNight = 'mapbox://styles/mapbox/navigation-night-v1';
  static const String styleNavigationDay = 'mapbox://styles/mapbox/navigation-day-v1';

  // Endpoints REST de Mapbox API
  static const String directionsBaseUrl =
      'https://api.mapbox.com/directions/v5/mapbox/driving-traffic';
  static const String geocodingBaseUrl =
      'https://api.mapbox.com/geocoding/v5/mapbox.places';

  // Coordenadas por defecto (Bogotá, Colombia como referencia inicial si no se otorga GPS)
  static const double defaultLat = 4.60971;
  static const double defaultLng = -74.08175;
  static const double defaultZoom = 15.5;
  static const double navigationPitch = 60.0;
}
