import 'package:latlong2/latlong.dart';

class TollItem {
  final String name;
  final String locationName;
  final int priceCop; // Tarifa Categoría I (Vehículos livianos / Autos)
  final LatLng position;
  final String concession;

  TollItem({
    required this.name,
    required this.locationName,
    required this.priceCop,
    required this.position,
    required this.concession,
  });
}

class ColombiaTollsDatabase {
  static final List<TollItem> tolls = [
    TollItem(
      name: 'Peaje Niquía',
      locationName: 'Autopista Norte (Bello - Copacabana)',
      priceCop: 3100,
      position: const LatLng(6.3533, -75.5458),
      concession: 'HATOVIAL / Vinus',
    ),
    TollItem(
      name: 'Peaje Trapiche',
      locationName: 'Vía Barbosa - Girota',
      priceCop: 16200,
      position: const LatLng(6.4022, -75.4678),
      concession: 'VINUS S.A.S',
    ),
    TollItem(
      name: 'Peaje Las Palmas (Variante)',
      locationName: 'Vía Las Palmas - Rionegro',
      priceCop: 15600,
      position: const LatLng(6.1667, -75.5250),
      concession: 'Devimed',
    ),
    TollItem(
      name: 'Peaje Túnel de Oriente',
      locationName: 'Conexión Aburrá - Oriente',
      priceCop: 23800,
      position: const LatLng(6.2044, -75.5125),
      concession: 'Concesión Túnel de Oriente',
    ),
    TollItem(
      name: 'Peaje Pandequeso',
      locationName: 'Envigado / Sabaneta (Variante Caldas)',
      priceCop: 14100,
      position: const LatLng(6.1250, -75.6208),
      concession: 'Pacífico 1',
    ),
    TollItem(
      name: 'Peaje Amagá',
      locationName: 'Vía Caldas - Amagá (Suroeste)',
      priceCop: 16500,
      position: const LatLng(6.0417, -75.7000),
      concession: 'Covipacífico',
    ),
    TollItem(
      name: 'Peaje El Santuario',
      locationName: 'Autopista Medellín - Bogotá',
      priceCop: 15900,
      position: const LatLng(6.0500, -75.2667),
      concession: 'Devimed',
    ),
  ];

  static int calculateTotalTolls(LatLng start, LatLng end) {
    // Estimación simple de peajes cercanos en el radio de la ruta
    int total = 0;
    const distance = Distance();
    for (final t in tolls) {
      final dStart = distance.as(LengthUnit.Kilometer, start, t.position);
      final dEnd = distance.as(LengthUnit.Kilometer, end, t.position);
      if (dStart < 15 || dEnd < 15) {
        total += t.priceCop;
      }
    }
    return total;
  }
}
