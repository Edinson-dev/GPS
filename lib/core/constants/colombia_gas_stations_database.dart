import 'package:latlong2/latlong.dart';

class GasStationItem {
  final String name;
  final String brand; // 'Terpel', 'Texaco', 'Primax', 'EPM Eléctrica'
  final String address;
  final LatLng position;
  final bool isElectricCharging;

  GasStationItem({
    required this.name,
    required this.brand,
    required this.address,
    required this.position,
    required this.isElectricCharging,
  });
}

class ColombiaGasStationsDatabase {
  static final List<GasStationItem> stations = [
    // Gasolineras
    GasStationItem(
      name: 'EDS Terpel Autopista Norte',
      brand: 'Terpel',
      address: 'Bello (Autopista Norte # 28-10)',
      position: const LatLng(6.3250, -75.5569),
      isElectricCharging: false,
    ),
    GasStationItem(
      name: 'EDS Texaco Las Vegas',
      brand: 'Texaco',
      address: 'Envigado (Av. Las Vegas # 25 Sur-15)',
      position: const LatLng(6.1825, -75.5861),
      isElectricCharging: false,
    ),
    GasStationItem(
      name: 'EDS Primax Industriales',
      brand: 'Primax',
      address: 'Medellín (Carrera 48 # 24-50)',
      position: const LatLng(6.2281, -75.5744),
      isElectricCharging: false,
    ),
    GasStationItem(
      name: 'EDS Terpel El Poblado',
      brand: 'Terpel',
      address: 'El Poblado (Calle 10 # 43A-20)',
      position: const LatLng(6.2106, -75.5722),
      isElectricCharging: false,
    ),
    // Puntos de Carga Eléctrica EPM
    GasStationItem(
      name: 'Electrolinera EPM Mayorca',
      brand: 'EPM Carga Eléctrica',
      address: 'Sabaneta (C.C. Mayorca Mega Plaza - Nivel Subterráneo 2)',
      position: const LatLng(6.1622, -75.5961),
      isElectricCharging: true,
    ),
    GasStationItem(
      name: 'Electrolinera EPM Viva Envigado',
      brand: 'EPM Carga Eléctrica',
      address: 'Envigado (C.C. Viva Envigado - Sotano 1)',
      position: const LatLng(6.1772, -75.5903),
      isElectricCharging: true,
    ),
    GasStationItem(
      name: 'Electrolinera EPM Santafé',
      brand: 'EPM Carga Eléctrica',
      address: 'El Poblado (C.C. Santafé Medellín - Parqueadero 1)',
      position: const LatLng(6.1975, -75.5736),
      isElectricCharging: true,
    ),
  ];
}
