import 'dart:async';
import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

class EmergencyAlert {
  final String id;
  final String nickname;
  final String vehicleType; // 'car' o 'bike'
  final String issueType; // 'mech', 'flat', 'fuel', 'crash'
  final String description;
  final LatLng position;
  final DateTime timestamp;

  EmergencyAlert({
    required this.id,
    required this.nickname,
    required this.vehicleType,
    required this.issueType,
    required this.description,
    required this.position,
    required this.timestamp,
  });

  factory EmergencyAlert.fromJson(String id, Map<String, dynamic> json) {
    return EmergencyAlert(
      id: id,
      nickname: json['nickname'] ?? 'Conductor',
      vehicleType: json['vehicleType'] ?? 'bike',
      issueType: json['issueType'] ?? 'mech',
      description: json['description'] ?? 'Solicita auxilio vial',
      position: LatLng(
        (json['lat'] as num?)?.toDouble() ?? 6.2494,
        (json['lng'] as num?)?.toDouble() ?? -75.5681,
      ),
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        json['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'vehicleType': vehicleType,
      'issueType': issueType,
      'description': description,
      'lat': position.latitude,
      'lng': position.longitude,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }
}

class EmergenciesService {
  final Dio _dio = Dio();
  static const String _dbUrl =
      'https://flutter-ai-playground-52ad9-default-rtdb.firebaseio.com/emergencies';

  final _emergenciesController = StreamController<List<EmergencyAlert>>.broadcast();
  Stream<List<EmergencyAlert>> get emergenciesStream => _emergenciesController.stream;

  Timer? _syncTimer;

  EmergenciesService() {
    startSync();
  }

  void startSync() {
    _fetchEmergencies();
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      _fetchEmergencies();
    });
  }

  void dispose() {
    _syncTimer?.cancel();
    _emergenciesController.close();
  }

  Future<void> publishEmergency({
    required String nickname,
    required String vehicleType,
    required String issueType,
    required String description,
    required LatLng position,
  }) async {
    final alert = EmergencyAlert(
      id: 'sos_${DateTime.now().millisecondsSinceEpoch}',
      nickname: nickname.trim().isEmpty ? 'Conductor' : nickname.trim(),
      vehicleType: vehicleType,
      issueType: issueType,
      description: description,
      position: position,
      timestamp: DateTime.now(),
    );

    try {
      await _dio.put(
        '$_dbUrl/${alert.id}.json',
        data: alert.toJson(),
      );
      _fetchEmergencies();
    } catch (_) {}
  }

  Future<void> resolveEmergency(String id) async {
    try {
      await _dio.delete('$_dbUrl/$id.json');
      _fetchEmergencies();
    } catch (_) {}
  }

  Future<void> _fetchEmergencies() async {
    try {
      final res = await _dio.get('$_dbUrl.json');
      if (res.statusCode == 200 && res.data is Map) {
        final Map map = res.data;
        final List<EmergencyAlert> list = [];
        final now = DateTime.now();

        map.forEach((key, val) {
          if (val is Map) {
            final alert = EmergencyAlert.fromJson(key.toString(), val.cast<String, dynamic>());
            // Filtrar alertas activas en las últimas 2 horas
            if (now.difference(alert.timestamp).inHours < 2) {
              list.add(alert);
            } else {
              resolveEmergency(key.toString());
            }
          }
        });

        _emergenciesController.add(list);
      } else {
        _emergenciesController.add([]);
      }
    } catch (_) {
      _emergenciesController.add([]);
    }
  }
}
