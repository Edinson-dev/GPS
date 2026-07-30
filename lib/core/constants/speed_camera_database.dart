import 'package:latlong2/latlong.dart';

class SpeedCameraItem {
  final String id;
  final String locationName;
  final int maxSpeedKmh;
  final LatLng position;
  final String type; // 'fija', 'semaforo', 'velocidad'

  SpeedCameraItem({
    required this.id,
    required this.locationName,
    required this.maxSpeedKmh,
    required this.position,
    required this.type,
  });
}

class SpeedCameraDatabase {
  static final List<SpeedCameraItem> cameras = [
    SpeedCameraItem(
      id: 'cam_01',
      locationName: 'Av. Regional (Frente a Terminal Norte)',
      maxSpeedKmh: 60,
      position: const LatLng(6.2794, -75.5689),
      type: 'velocidad',
    ),
    SpeedCameraItem(
      id: 'cam_02',
      locationName: 'Av. Regional (Cerca de Parque Explora / Calle 73)',
      maxSpeedKmh: 60,
      position: const LatLng(6.2700, -75.5661),
      type: 'velocidad',
    ),
    SpeedCameraItem(
      id: 'cam_03',
      locationName: 'Av. Las Vegas (Frente a EAFIT - Calle 12 Sur)',
      maxSpeedKmh: 50,
      position: const LatLng(6.1989, -75.5794),
      type: 'velocidad',
    ),
    SpeedCameraItem(
      id: 'cam_04',
      locationName: 'Av. El Poblado (Carrera 43A con Calle 10)',
      maxSpeedKmh: 50,
      position: const LatLng(6.2117, -75.5728),
      type: 'semaforo',
    ),
    SpeedCameraItem(
      id: 'cam_05',
      locationName: 'Calle 30 (Frente a Premium Plaza)',
      maxSpeedKmh: 50,
      position: const LatLng(6.2289, -75.5706),
      type: 'velocidad',
    ),
    SpeedCameraItem(
      id: 'cam_06',
      locationName: 'Autopista Norte (Bello - Frente a Postobón)',
      maxSpeedKmh: 60,
      position: const LatLng(6.3311, -75.5564),
      type: 'velocidad',
    ),
    SpeedCameraItem(
      id: 'cam_07',
      locationName: 'Calle 80 (Robledo - Frente a ITM)',
      maxSpeedKmh: 50,
      position: const LatLng(6.2758, -75.5892),
      type: 'velocidad',
    ),
  ];
}
