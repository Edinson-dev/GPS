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
      title: 'Estación Metro Cisneros',
      address: 'Medellín (Calle 44 # 57-10 - Parque de Las Luces)',
      category: 'metro',
      position: const LatLng(6.2464, -75.5744),
      keywords: ['cisneros', 'metro cisneros', 'estacion cisneros', 'parque de las luces', 'san juan'],
    ),
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
    // METROPLÚS - LÍNEA 1 & 2
    // ----------------------------------------------------
    LocalPoiItem(
      title: 'Estación Metroplús Universidad de Medellín',
      address: 'Medellín (Calle 30 # 87-20 - Belén)',
      category: 'metroplus',
      position: const LatLng(6.2317, -75.6094),
      keywords: ['u de m', 'universidad de medellin', 'metroplus u de m', 'estacion udem'],
    ),
    LocalPoiItem(
      title: 'Estación Metroplús Los Alpes',
      address: 'Medellín (Calle 30 # 83-10 - Belén)',
      category: 'metroplus',
      position: const LatLng(6.2325, -75.6050),
      keywords: ['los alpes', 'metroplus los alpes', 'estacion los alpes'],
    ),
    LocalPoiItem(
      title: 'Estación Metroplús La Palma',
      address: 'Medellín (Calle 30 # 80-15 - Belén)',
      category: 'metroplus',
      position: const LatLng(6.2333, -75.6006),
      keywords: ['la palma', 'metroplus la palma', 'estacion la palma'],
    ),
    LocalPoiItem(
      title: 'Estación Metroplús Parque de Belén',
      address: 'Medellín (Calle 30 # 76-10 - Belén)',
      category: 'metroplus',
      position: const LatLng(6.2344, -75.5961),
      keywords: ['parque belen', 'metroplus belen', 'estacion parque de belen'],
    ),
    LocalPoiItem(
      title: 'Estación Metroplús Rosales',
      address: 'Medellín (Calle 30 # 70-20 - Belén Rosales)',
      category: 'metroplus',
      position: const LatLng(6.2356, -75.5906),
      keywords: ['rosales', 'metroplus rosales', 'estacion rosales'],
    ),
    LocalPoiItem(
      title: 'Estación Metroplús Fátima',
      address: 'Medellín (Calle 30 # 65-10 - Fátima)',
      category: 'metroplus',
      position: const LatLng(6.2367, -75.5842),
      keywords: ['fatima', 'metroplus fatima', 'estacion fatima'],
    ),
    LocalPoiItem(
      title: 'Estación Metroplús Nutibara / Pueblito Paisa',
      address: 'Medellín (Calle 30 # 55-20)',
      category: 'metroplus',
      position: const LatLng(6.2375, -75.5789),
      keywords: ['nutibara', 'metroplus nutibara', 'pueblito paisa', 'estacion nutibara'],
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
    // BARRIOS Y COMUNAS DEL VALLE DE ABURRÁ Y COLOMBIA
    // ----------------------------------------------------
    LocalPoiItem(
      title: 'Barrio Alfonso López',
      address: 'Medellín, Antioquia (Comuna 5 - Castilla)',
      category: 'neighborhood',
      position: const LatLng(6.2875, -75.5678),
      keywords: ['alfonso lopez', 'barrio alfonso lopez', 'castilla', 'comuna 5'],
    ),
    LocalPoiItem(
      title: 'Barrio El Poblado',
      address: 'Medellín, Antioquia (Comuna 14)',
      category: 'neighborhood',
      position: const LatLng(6.2089, -75.5678),
      keywords: ['poblado', 'el poblado', 'comuna 14'],
    ),
    LocalPoiItem(
      title: 'Barrio Laureles',
      address: 'Medellín, Antioquia (Comuna 11)',
      category: 'neighborhood',
      position: const LatLng(6.2442, -75.5908),
      keywords: ['laureles', 'barrio laureles', 'comuna 11'],
    ),
    LocalPoiItem(
      title: 'Barrio Belén',
      address: 'Medellín, Antioquia (Comuna 16)',
      category: 'neighborhood',
      position: const LatLng(6.2308, -75.5964),
      keywords: ['belen', 'barrio belen', 'comuna 16'],
    ),
    LocalPoiItem(
      title: 'Barrio Robledo',
      address: 'Medellín, Antioquia (Comuna 7)',
      category: 'neighborhood',
      position: const LatLng(6.2750, -75.5917),
      keywords: ['robledo', 'barrio robledo', 'comuna 7'],
    ),
    LocalPoiItem(
      title: 'Barrio Envigado Centro',
      address: 'Envigado, Antioquia (Parque Principal Envigado)',
      category: 'neighborhood',
      position: const LatLng(6.1706, -75.5861),
      keywords: ['envigado', 'parque envigado', 'envigado centro'],
    ),
    LocalPoiItem(
      title: 'Barrio Sabaneta Cañaveralejo',
      address: 'Sabaneta, Antioquia (Parque de Sabaneta)',
      category: 'neighborhood',
      position: const LatLng(6.1517, -75.6156),
      keywords: ['sabaneta', 'parque sabaneta', 'sabaneta centro'],
    ),
    LocalPoiItem(
      title: 'Barrio Itagüí Centro',
      address: 'Itagüí, Antioquia (Parque Principal Itagüí)',
      category: 'neighborhood',
      position: const LatLng(6.1728, -75.6094),
      keywords: ['itagui', 'parque itagui', 'itagui centro'],
    ),
    LocalPoiItem(
      title: 'Barrio Alfonso López (Cali)',
      address: 'Cali, Valle del Cauca (Comuna 7)',
      category: 'neighborhood',
      position: const LatLng(3.4611, -76.4972),
      keywords: ['alfonso lopez cali', 'barrio alfonso lopez cali'],
    ),
    LocalPoiItem(
      title: 'Barrio Alfonso López (Bogotá)',
      address: 'Bogotá, D.C. (Usme)',
      category: 'neighborhood',
      position: const LatLng(4.5125, -74.1167),
      keywords: ['alfonso lopez bogota', 'barrio alfonso lopez bogota'],
    ),

    // ----------------------------------------------------
    // CENTROS COMERCIALES Y PUNTOS DE INTERÉS CLAVE
    // ----------------------------------------------------
    LocalPoiItem(
      title: 'Centro Comercial Mayorca Mega Plaza',
      address: 'Sabaneta / Itagüí (Calle 51 Sur # 48-57)',
      category: 'mall',
      position: const LatLng(6.1625, -75.5964),
      keywords: ['mayorca', 'centro comercial mayorca', 'sabaneta', 'itagui'],
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

    // ----------------------------------------------------
    // PARQUES EMBLEMÁTICOS Y LUGARES EMBLEMÁTICOS DE COLOMBIA
    // ----------------------------------------------------
    LocalPoiItem(
      title: 'Parque de las Luces (Plaza de Cisneros)',
      address: 'Medellín, Antioquia (Calle 44 # 52-50 - El Centro)',
      category: 'landmark',
      position: const LatLng(6.2458, -75.5714),
      keywords: ['parque de las luces', 'plaza cisneros', 'luces', 'biblioteca epm', 'cisneros'],
    ),
    LocalPoiItem(
      title: 'Parque Lleras',
      address: 'Medellín, Antioquia (Carrera 37A # 9-15 - El Poblado)',
      category: 'landmark',
      position: const LatLng(6.2086, -75.5678),
      keywords: ['parque lleras', 'lleras', 'poblado lleras', 'zona rosa'],
    ),
    LocalPoiItem(
      title: 'Plaza Botero (Museo de Antioquia)',
      address: 'Medellín, Antioquia (Carrera 52 # 52-43 - Centro)',
      category: 'landmark',
      position: const LatLng(6.2517, -75.5681),
      keywords: ['plaza botero', 'esculturas botero', 'museo de antioquia', 'botero'],
    ),
    LocalPoiItem(
      title: 'Pueblito Paisa (Cerro Nutibara)',
      address: 'Medellín, Antioquia (Calle 30A # 55-64)',
      category: 'landmark',
      position: const LatLng(6.2367, -75.5789),
      keywords: ['pueblito paisa', 'cerro nutibara', 'nutibara', 'mirador medellin'],
    ),
    LocalPoiItem(
      title: 'Parque Explora & Planetario',
      address: 'Medellín, Antioquia (Carrera 52 # 73-75)',
      category: 'landmark',
      position: const LatLng(6.2708, -75.5658),
      keywords: ['parque explora', 'explora', 'planetario', 'acuario explora'],
    ),
    LocalPoiItem(
      title: 'Jardín Botánico Joaquín Antonio Uribe',
      address: 'Medellín, Antioquia (Calle 73 # 51D-14)',
      category: 'landmark',
      position: const LatLng(6.2703, -75.5639),
      keywords: ['jardin botanico', 'orquideorama', 'botanico'],
    ),
    LocalPoiItem(
      title: 'Parque Arví',
      address: 'Medellín, Santa Elena (Metrocable L)',
      category: 'landmark',
      position: const LatLng(6.2819, -75.5036),
      keywords: ['parque arvi', 'arvi', 'santa elena', 'metrocable arvi'],
    ),
    LocalPoiItem(
      title: 'Parque de los Deseos',
      address: 'Medellín, Antioquia (Carrera 52 # 71-117)',
      category: 'landmark',
      position: const LatLng(6.2683, -75.5658),
      keywords: ['parque de los deseos', 'deseos', 'casa de la musica'],
    ),
    LocalPoiItem(
      title: 'Parque Simón Bolívar (Montería, Córdoba)',
      address: 'Montería, Córdoba (Carrera 3 con Calle 27)',
      category: 'landmark',
      position: const LatLng(8.7564, -75.8872),
      keywords: ['parque simon bolivar monteria', 'monteria', 'cordoba', 'parque centro monteria'],
    ),

    // ----------------------------------------------------
    // BOGOTÁ D.C. Y CUNDINAMARCA
    // ----------------------------------------------------
    LocalPoiItem(
      title: 'Cerro de Monserrate',
      address: 'Bogotá D.C. (Carrera 2 Este # 21-48)',
      category: 'landmark',
      position: const LatLng(4.6058, -74.0556),
      keywords: ['monserrate', 'cerro de monserrate', 'bogota', 'santuario monserrate'],
    ),
    LocalPoiItem(
      title: 'Barrio La Candelaria (Centro Histórico)',
      address: 'Bogotá D.C. (Calle 10 con Carrera 3)',
      category: 'neighborhood',
      position: const LatLng(4.5969, -74.0728),
      keywords: ['la candelaria', 'candelaria', 'centro historico bogota', 'plaza de bolivar'],
    ),
    LocalPoiItem(
      title: 'Parque de la 93',
      address: 'Bogotá D.C. (Calle 93 # 11A-11 - Chapinero)',
      category: 'landmark',
      position: const LatLng(4.6767, -74.0483),
      keywords: ['parque de la 93', 'parque 93', 'zona rosa bogota', 'chapinero'],
    ),
    LocalPoiItem(
      title: 'Parque Metropolitano Simón Bolívar',
      address: 'Bogotá D.C. (Calle 63 y Calle 53 - Teusaquillo)',
      category: 'landmark',
      position: const LatLng(4.6583, -74.0939),
      keywords: ['parque simon bolivar bogota', 'simon bolivar', 'teusaquillo'],
    ),
    LocalPoiItem(
      title: 'Aeropuerto Internacional El Dorado (BOG)',
      address: 'Bogotá D.C. (Avenida El Dorado # 103-9)',
      category: 'airport',
      position: const LatLng(4.7016, -74.1469),
      keywords: ['el dorado', 'aeropuerto el dorado', 'bogota airport', 'bog'],
    ),
    LocalPoiItem(
      title: 'Catedral de Sal de Zipaquirá',
      address: 'Zipaquirá, Cundinamarca (Parque de la Sal)',
      category: 'landmark',
      position: const LatLng(5.0189, -74.0094),
      keywords: ['catedral de sal', 'zipaquira', 'cundinamarca', 'mina de sal'],
    ),

    // ----------------------------------------------------
    // COSTA CARIBE (CARTAGENA, BARRANQUILLA, SANTA MARTA, MONTERÍA)
    // ----------------------------------------------------
    LocalPoiItem(
      title: 'Ciudad Amurallada de Cartagena',
      address: 'Cartagena, Bolívar (Centro Histórico)',
      category: 'landmark',
      position: const LatLng(10.4236, -75.5511),
      keywords: ['ciudad amurallada', 'cartagena', 'centro historico cartagena', 'torre del reloj'],
    ),
    LocalPoiItem(
      title: 'Castillo de San Felipe de Barajas',
      address: 'Cartagena, Bolívar (Pie de la Popa)',
      category: 'landmark',
      position: const LatLng(10.4225, -75.5392),
      keywords: ['castillo san felipe', 'san felipe', 'cartagena castillo'],
    ),
    LocalPoiItem(
      title: 'Barrio Bocagrande',
      address: 'Cartagena, Bolívar (Avenida San Martín)',
      category: 'neighborhood',
      position: const LatLng(10.4022, -75.5558),
      keywords: ['bocagrande', 'playa bocagrande', 'cartagena bocagrande'],
    ),
    LocalPoiItem(
      title: 'Gran Malecón del Río',
      address: 'Barranquilla, Atlántico (Vía 40)',
      category: 'landmark',
      position: const LatLng(11.0117, -74.7825),
      keywords: ['gran malecon', 'malecon del rio', 'barranquilla', 'malecon'],
    ),
    LocalPoiItem(
      title: 'Monumento Ventana al Mundo',
      address: 'Barranquilla, Atlántico (Circunvalar)',
      category: 'landmark',
      position: const LatLng(11.0267, -74.8250),
      keywords: ['ventana al mundo', 'barranquilla ventana', 'monumento barranquilla'],
    ),
    LocalPoiItem(
      title: 'Parque Nacional Natural Tayrona',
      address: 'Santa Marta, Magdalena (Vía Riohacha)',
      category: 'landmark',
      position: const LatLng(11.3108, -74.0733),
      keywords: ['tayrona', 'parque tayrona', 'cabo san juan', 'santa marta tayrona'],
    ),
    LocalPoiItem(
      title: 'El Rodadero',
      address: 'Santa Marta, Magdalena (Carrera 1)',
      category: 'neighborhood',
      position: const LatLng(11.2056, -74.2289),
      keywords: ['el rodadero', 'rodadero', 'santa marta rodadero', 'playa rodadero'],
    ),
    LocalPoiItem(
      title: 'Ronda del Sinú (Montería)',
      address: 'Montería, Córdoba (Avenida Primera / Carrera 1)',
      category: 'landmark',
      position: const LatLng(8.7533, -75.8889),
      keywords: ['ronda del sinu', 'rio sinu', 'monteria ronda', 'parque lineal'],
    ),

    // ----------------------------------------------------
    // CALI Y VALLE DEL CAUCA
    // ----------------------------------------------------
    LocalPoiItem(
      title: 'Cristo Rey (Cali)',
      address: 'Cali, Valle del Cauca (Corregimiento Los Andes)',
      category: 'landmark',
      position: const LatLng(3.4358, -76.5658),
      keywords: ['cristo rey cali', 'cristo rey', 'cali mirador'],
    ),
    LocalPoiItem(
      title: 'Bulevar del Río & Iglesia La Ermita',
      address: 'Cali, Valle del Cauca (Avenida Colombia - Centro)',
      category: 'landmark',
      position: const LatLng(3.4525, -76.5328),
      keywords: ['bulevar del rio', 'la ermita', 'cali centro', 'ermita'],
    ),
    LocalPoiItem(
      title: 'Aeropuerto Internacional Alfonso Bonilla Aragón (CLO)',
      address: 'Palmira / Cali, Valle del Cauca',
      category: 'airport',
      position: const LatLng(3.5431, -76.3816),
      keywords: ['bonilla aragon', 'aeropuerto cali', 'clo', 'palmira airport'],
    ),

    // ----------------------------------------------------
    // EJE CAFETERO (SALENTO, COCORA, PARQUE DEL CAFÉ)
    // ----------------------------------------------------
    LocalPoiItem(
      title: 'Valle de Cocora & Salento',
      address: 'Salento, Quindío (Vía Valle de Cocora)',
      category: 'landmark',
      position: const LatLng(4.6383, -75.5458),
      keywords: ['valle de cocora', 'cocora', 'salento', 'palmas de cera', 'quindio'],
    ),
    LocalPoiItem(
      title: 'Parque Nacional del Café',
      address: 'Montenegro, Quindío (Km 4 Vía Pueblo Tapao)',
      category: 'landmark',
      position: const LatLng(4.5408, -75.7708),
      keywords: ['parque del cafe', 'parque nacional del cafe', 'montenegro', 'quindio'],
    ),
    LocalPoiItem(
      title: 'Nevado del Ruiz',
      address: 'Manizales / Tolima / Caldas (Parque Nacional Los Nevados)',
      category: 'landmark',
      position: const LatLng(4.8925, -75.3189),
      keywords: ['nevado del ruiz', 'los nevados', 'manizales', 'volcan ruiz'],
    ),

    // ----------------------------------------------------
    // SANTANDERES Y PACÍFICO / SUR DE COLOMBIA
    // ----------------------------------------------------
    LocalPoiItem(
      title: 'Parque Nacional del Chicamocha (PANACHI)',
      address: 'Aratoca, Santander (Vía Bucaramanga - San Gil)',
      category: 'landmark',
      position: const LatLng(6.7908, -73.0039),
      keywords: ['panachi', 'chicamocha', 'canon del chicamocha', 'santander'],
    ),
    LocalPoiItem(
      title: 'Santuario de Nuestra Señora de Las Lajas',
      address: 'Ipiales, Nariño (Corregimiento de Las Lajas)',
      category: 'landmark',
      position: const LatLng(0.8053, -77.5861),
      keywords: ['las lajas', 'santuario las lajas', 'ipiales', 'narino'],
    ),
    LocalPoiItem(
      title: 'Desierto de la Tatacoa',
      address: 'Villavieja, Huila (A 38 km de Neiva)',
      category: 'landmark',
      position: const LatLng(3.2308, -75.1678),
      keywords: ['tatacoa', 'desierto de la tatacoa', 'huila', 'villavieja'],
    ),
    LocalPoiItem(
      title: 'Caño Cristales (El Río de los 5 Colores)',
      address: 'La Macarena, Meta (Serranía de la Macarena)',
      category: 'landmark',
      position: const LatLng(2.2567, -73.7878),
      keywords: ['cano cristales', 'rio de 5 colores', 'la macarena', 'meta'],
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
