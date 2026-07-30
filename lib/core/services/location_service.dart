import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class UserLocation {
  final LatLng position;
  final double speedKmh;
  final double heading;
  final double altitude;

  UserLocation({
    required this.position,
    required this.speedKmh,
    required this.heading,
    required this.altitude,
  });
}

class LocationService {
  StreamSubscription<Position>? _positionStreamSub;

  Future<bool> checkAndRequestPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await checkAndRequestPermissions();
      if (!hasPermission) return null;

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  Stream<UserLocation> getRealtimeLocationStream() async* {
    final hasPermission = await checkAndRequestPermissions();
    if (!hasPermission) return;

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 2,
    );

    yield* Geolocator.getPositionStream(locationSettings: locationSettings)
        .map((position) {
      final speedKmh = (position.speed < 0 ? 0 : position.speed) * 3.6;
      return UserLocation(
        position: LatLng(position.latitude, position.longitude),
        speedKmh: speedKmh,
        heading: position.heading,
        altitude: position.altitude,
      );
    });
  }

  void dispose() {
    _positionStreamSub?.cancel();
  }
}
