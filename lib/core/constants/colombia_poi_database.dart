import 'package:latlong2/latlong.dart';

class LocalPoiItem {
  final String title;
  final String address;
  final String category;
  final LatLng position;
  final List<String> keywords;

  LocalPoiItem({
    required this.title,
    required this.address,
    required this.category,
    required this.position,
    required this.keywords,
  });
}

class ColombiaPoiDatabase {
  static final List<LocalPoiItem> pointsOfInterest = [
    // ----------------------------------------------------
    // METRO DE MEDELLÍN - LÍNEA A (Norte a Sur)
    // ----------------------------------------------------
    LocalPoiItem(
      title: 'Estación Metro Niquía',
      address: 'Bello, Antioquia (Diagonal 50 # 38-20)',
      category: 'metro',
      position: const LatLng(6.3468, -75.5492),
      keywords: ['niquia', 'metro niquia', 'bello', 'estacion niquia'],
    ),
    LocalPoiItem(
      title: 'Estación Metro Bello',
      address: 'Bello, Antioquia (Calle 44 # 46-50)',
      category: 'metro',
      position: const LatLng(6.3339, -75.5547),
      keywords: ['bello', 'metro bello', 'estacion bello'],
    ),
    LocalPoiItem(
      title: 'Estación Metro Madera',
      address: 'Bello, Antioquia (Carrera 49 # 26-10)',
      category: 'metro',
      position: const LatLng(6.3164, -75.5578),
      keywords: ['madera', 'metro madera', 'estacion madera'],
    ),
    LocalPoiItem(
      title: 'Estación Metro Acevedo',
      address: 'Medellín (Carrera 63 # 103-10)',
      category: 'metro',
      position: const LatLng(6.3009, -75.5583),
      keywords: ['acevedo', 'metro acevedo', 'metrocable K', 'estacion acevedo'],
    ),
    LocalPoiItem(
      title: 'Estación Metro Tricentenario',
      address: 'Medellín (Carrera 63 # 94-20)',
      category: 'metro',
      position: const LatLng(6.2894, -75.5647),
      keywords: ['tricentenario', 'metro tricentenario', 'estacion tricentenario'],
    ),
    LocalPoiItem(
      title: 'Estación Metro Caribe',
      address: 'Medellín (Carrera 64 # 75B-150 - Frente a Terminal Norte)',
      category: 'metro',
      position: const LatLng(6.2783, -75.5694),
      keywords: ['caribe', 'metro caribe', 'terminal norte', 'estacion caribe'],
    ),
    LocalPoiItem(
      title: 'Estación Metro Universidad',
      address: 'Medellín (Calle 73 # 52-20 - Frente al Parque Explora)',
      category: 'metro',
      position: const LatLng(6.2694, -75.5658),
      keywords: ['universidad', 'metro universidad', 'udea', 'parque explora', 'estacion universidad'],
    ),
    LocalPoiItem(
      title: 'Estación Metro Hospital',
      address: 'Medellín (Carrera 51 # 66-20)',
      category: 'metro',
      position: const LatLng(6.2639, -75.5647),
      keywords: ['hospital', 'metro hospital', 'san vicente', 'estacion hospital'],
    ),
    LocalPoiItem(
      title: 'Estación Metro Prado',
      address: 'Medellín (Carrera 51 # 58-30)',
      category: 'metro',
      position: const LatLng(6.2558, -75.5661),
      keywords: ['prado', 'metro prado', 'estacion prado'],
    ),
    LocalPoiItem(
      title: 'Estación Metro Parque Berrío',
      address: 'Medellín (Carrera 51 # 50-20 - Centro)',
      category: 'metro',
      position: const LatLng(6.2494, -75.5681),
      keywords: ['parque berrio', 'metro parque berrio', 'centro', 'estacion parque berrio'],
    ),
    LocalPoiItem(
      title: 'Estación Metro San Antonio',
      address: 'Medellín (Carrera 51 # 45-50 - Trasbordo Línea B y Tranvía)',
      category: 'metro',
      position: const LatLng(6.2447, -75.5694),
      keywords: ['san antonio', 'metro san antonio', 'tranvia', 'linea b', 'estacion san antonio'],
    ),
    LocalPoiItem(
      title: 'Estación Metro Alpujarra',
      address: 'Medellín (Carrera 51 # 41-20 - Gobernación y Alcaldía)',
      category: 'metro',
      position: const LatLng(6.2411, -75.5706),
      keywords: ['alpujarra', 'metro alpujarra', 'alcaldia', 'gobernacion', 'estacion alpujarra'],
    ),
    LocalPoiItem(
      title: 'Estación Metro Exposiciones',
      address: 'Medellín (Carrera 51 # 37-10 - Plaza Mayor)',
      category: 'metro',
      position: const LatLng(6.2361, -75.5719),
      keywords: ['exposiciones', 'metro exposiciones', 'plaza mayor', 'estacion exposiciones'],
    ),
    LocalPoiItem(
      title: 'Estación Metro Industriales',
      address: 'Medellín (Carrera 49 # 26-20 - Trasbordo Metroplús)',
      category: 'metro',
      position: const LatLng(6.2294, -75.5742),
      keywords: ['industriales', 'metro industriales', 'metroplus', 'estacion industriales'],
    ),
    LocalPoiItem(
      title: 'Estación Metro Poblado',
      address: 'Medellín (Carrera 49 # 10-10 - El Poblado)',
      category: 'metro',
      position: const LatLng(6.2125, -75.5781),
      keywords: ['poblado', 'metro poblado', 'el poblado', 'estacion poblado'],
    ),
    LocalPoiItem(
      title: 'Estación Metro Aguacatala',
      address: 'Medellín (Carrera 48 # 12 S-10)',
      category: 'metro',
      position: const LatLng(6.1972, -75.5806),
      keywords: ['aguacatala', 'metro aguacatala', 'eafit', 'estacion aguacatala'],
    ),
    LocalPoiItem(
      title: 'Estación Metro Ayurá',
      address: 'Envigado (Carrera 48 # 25 S-10)',
      category: 'metro',
      position: const LatLng(6.1856, -75.5847),
      keywords: ['ayura', 'metro ayura', 'envigado', 'estacion ayura'],
    ),
    LocalPoiItem(
      title: 'Estación Metro Envigado',
      address: 'Envigado (Carrera 48 # 37 S-20)',
      category: 'metro',
      position: const LatLng(6.1750, -75.5908),
      keywords: ['envigado', 'metro envigado', 'estacion envigado'],
    ),
    LocalPoiItem(
      title: 'Estación Metro Itagüí',
      address: 'Itagüí (Carrera 49 # 50-10)',
      category: 'metro',
      position: const LatLng(6.1644, -75.5975),
      keywords: ['itagui', 'metro itagui', 'mayorca', 'estacion itagui'],
    ),
    LocalPoiItem(
      title: 'Estación Metro Sabaneta',
      address: 'Sabaneta (Carrera 49 # 67 S-10)',
      category: 'metro',
      position: const LatLng(6.1517, -75.6047),
      keywords: ['sabaneta', 'metro sabaneta', 'estacion sabaneta'],
    ),
    LocalPoiItem(
      title: 'Estación Metro La Estrella',
      address: 'Sabaneta / La Estrella (Carrera 49 # 77 S-20)',
      category: 'metro',
      position: const LatLng(6.1417, -75.6111),
      keywords: ['la estrella', 'metro la estrella', 'estacion la estrella'],
    ),

    // ----------------------------------------------------
    // METRO DE MEDELLÍN - LÍNEA B (Occidente)
    // ----------------------------------------------------
    LocalPoiItem(
      title: 'Estación Metro Suramericana',
      address: 'Medellín (Calle 48 # 65-10)',
      category: 'metro',
      position: const LatLng(6.2525, -75.5847),
      keywords: ['suramericana', 'metro suramericana', 'estacion suramericana'],
    ),
    LocalPoiItem(
      title: 'Estación Metro Estadio',
      address: 'Medellín (Calle 48 # 70-10 - Atanasio Girardot)',
      category: 'metro',
      position: const LatLng(6.2514, -75.5897),
      keywords: ['estadio', 'metro estadio', 'atanasio girardot', 'estacion estadio'],
    ),
    LocalPoiItem(
      title: 'Estación Metro Floresta',
      address: 'Medellín (Calle 48 # 80-10)',
      category: 'metro',
      position: const LatLng(6.2503, -75.5969),
      keywords: ['floresta', 'metro floresta', 'estacion floresta'],
    ),
    LocalPoiItem(
      title: 'Estación Metro Santa Lucía',
      address: 'Medellín (Calle 48 # 86-10)',
      category: 'metro',
      position: const LatLng(6.2492, -75.6033),
      keywords: ['santa lucia', 'metro santa lucia', 'estacion santa lucia'],
    ),
    LocalPoiItem(
      title: 'Estación Metro San Javier',
      address: 'Medellín (Calle 44 # 99-10 - Comuna 13 y Metrocable J)',
      category: 'metro',
      position: const LatLng(6.2481, -75.6119),
      keywords: ['san javier', 'metro san javier', 'comuna 13', 'metrocable', 'estacion san javier'],
    ),

    // ----------------------------------------------------
    // TERMINALES DE TRANSPORTE Y AEROPUERTOS
    // ----------------------------------------------------
    LocalPoiItem(
      title: 'Terminal de Transportes del Norte',
      address: 'Medellín (Carrera 64C # 78-580 - Caribe)',
      category: 'terminal',
      position: const LatLng(6.2789, -75.5689),
      keywords: ['terminal norte', 'terminal del norte', 'buses norte', 'caribe'],
    ),
    LocalPoiItem(
      title: 'Terminal de Transportes del Sur',
      address: 'Medellín (Carrera 65 # 8B-91 - Guayabal)',
      category: 'terminal',
      position: const LatLng(6.2164, -75.5861),
      keywords: ['terminal sur', 'terminal del sur', 'buses sur', 'guayabal'],
    ),
    LocalPoiItem(
      title: 'Aeropuerto Olaya Herrera (EOH)',
      address: 'Medellín (Carrera 65 # 13-157 - Guayabal)',
      category: 'airport',
      position: const LatLng(6.2189, -75.5892),
      keywords: ['aeropuerto olaya herrera', 'olaya herrera', 'eoh', 'aeropuerto medellin'],
    ),
    LocalPoiItem(
      title: 'Aeropuerto Internacional José María Córdova (MDE)',
      address: 'Rionegro, Antioquia (Vía Aeropuerto José María Córdova)',
      category: 'airport',
      position: const LatLng(6.1644, -75.4231),
      keywords: ['aeropuerto rionegro', 'jose maria cordova', 'mde', 'aeropuerto internacional'],
    ),

    // ----------------------------------------------------
    // CENTROS COMERCIALES Y PUNTOS DE INTERÉS CLAVE
    // ----------------------------------------------------
    LocalPoiItem(
      title: 'Centro Comercial Mayorca Mega Plaza',
      address: 'Sabaneta / Itagüí (Calle 51 Sur # 48-57)',
      category: 'mall',
      position: const LatLng(6.1625, -75.5964),
      keywords: ['mayorca', 'centro comercial mayorca', 'sabanaeta', 'itagui'],
    ),
    LocalPoiItem(
      title: 'Centro Comercial Viva Envigado',
      address: 'Envigado (Carrera 48 # 32B Sur-139)',
      category: 'mall',
      position: const LatLng(6.1775, -75.5900),
      keywords: ['viva envigado', 'centro comercial viva envigado', 'envigado'],
    ),
    LocalPoiItem(
      title: 'Centro Comercial Santafé Medellín',
      address: 'El Poblado (Carrera 43A # 7 Sur-170)',
      category: 'mall',
      position: const LatLng(6.1978, -75.5739),
      keywords: ['santafe', 'centro comercial santafe', 'poblado'],
    ),
    LocalPoiItem(
      title: 'Centro Comercial El Tesoro Parque Comercial',
      address: 'El Poblado (Carrera 25A # 1A Sur-45)',
      category: 'mall',
      position: const LatLng(6.2008, -75.5583),
      keywords: ['el tesoro', 'tesoro', 'centro comercial el tesoro', 'poblado'],
    ),
    LocalPoiItem(
      title: 'Plaza Mayor Medellín (Convenciones)',
      address: 'Medellín (Calle 41 # 55-80)',
      category: 'landmark',
      position: const LatLng(6.2417, -75.5750),
      keywords: ['plaza mayor', 'convenciones', 'alpujarra'],
    ),
    LocalPoiItem(
      title: 'Unidad Deportiva Atanasio Girardot',
      address: 'Medellín (Carrera 74 # 48010)',
      category: 'landmark',
      position: const LatLng(6.2567, -75.5903),
      keywords: ['estadio atanasio', 'unidad deportiva', 'estadio medellin'],
    ),
  ];

  static List<LocalPoiItem> searchLocalPois(String query) {
    if (query.trim().isEmpty) return [];
    final q = query.toLowerCase().trim();

    return pointsOfInterest.where((item) {
      final titleMatch = item.title.toLowerCase().contains(q);
      final addressMatch = item.address.toLowerCase().contains(q);
      final keywordMatch = item.keywords.any((k) => k.contains(q) || q.contains(k));
      return titleMatch || addressMatch || keywordMatch;
    }).toList();
  }
}
