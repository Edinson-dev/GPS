import 'dart:async';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

class CaravanMember {
  final String id;
  final String nickname;
  final String vehicleType; // 'car' o 'bike'
  final LatLng position;
  final double speedKmh;
  final DateTime lastUpdated;

  CaravanMember({
    required this.id,
    required this.nickname,
    required this.vehicleType,
    required this.position,
    required this.speedKmh,
    required this.lastUpdated,
  });

  factory CaravanMember.fromJson(String id, Map<String, dynamic> json) {
    return CaravanMember(
      id: id,
      nickname: json['nickname'] ?? 'Conductor',
      vehicleType: json['vehicleType'] ?? 'car',
      position: LatLng(
        (json['lat'] as num?)?.toDouble() ?? 6.2494,
        (json['lng'] as num?)?.toDouble() ?? -75.5681,
      ),
      speedKmh: (json['speedKmh'] as num?)?.toDouble() ?? 0.0,
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(
        json['lastUpdated'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'vehicleType': vehicleType,
      'lat': position.latitude,
      'lng': position.longitude,
      'speedKmh': speedKmh,
      'lastUpdated': lastUpdated.millisecondsSinceEpoch,
    };
  }
}

class CaravanService {
  final Dio _dio = Dio();
  static const String _dbUrl =
      'https://waypulse-default-rtdb.firebaseio.com/caravans';

  String? currentGroupCode;
  String? currentMemberId;
  Timer? _syncTimer;

  final _membersController = StreamController<List<CaravanMember>>.broadcast();
  Stream<List<CaravanMember>> get membersStream => _membersController.stream;

  // Generar un código único de caravana de 6 caracteres (ej: RODADA-9482)
  String generateCode() {
    final rand = Random().nextInt(8999) + 1000;
    return 'RODADA-$rand';
  }

  // Crear una nueva caravana en la nube
  Future<String> createCaravan({
    required String nickname,
    required String vehicleType,
    required LatLng initialPosition,
  }) async {
    final code = generateCode();
    currentGroupCode = code;
    currentMemberId = 'leader_${Random().nextInt(99999)}';

    final member = CaravanMember(
      id: currentMemberId!,
      nickname: nickname,
      vehicleType: vehicleType,
      position: initialPosition,
      speedKmh: 0.0,
      lastUpdated: DateTime.now(),
    );

    try {
      await _dio.put(
        '$_dbUrl/$code/members/$currentMemberId.json',
        data: member.toJson(),
      );
      _startSyncLoop();
    } catch (_) {}

    return code;
  }

  // Unirse a una caravana existente por código
  Future<bool> joinCaravan({
    required String code,
    required String nickname,
    required String vehicleType,
    required LatLng initialPosition,
  }) async {
    String cleanCode = code.trim().toUpperCase();
    if (!cleanCode.startsWith('RODADA-') && !cleanCode.startsWith('CARAVANA-')) {
      cleanCode = 'RODADA-$cleanCode';
    }
    currentGroupCode = cleanCode;
    currentMemberId = 'member_${Random().nextInt(99999)}';

    final member = CaravanMember(
      id: currentMemberId!,
      nickname: nickname.trim().isEmpty ? 'Conductor' : nickname.trim(),
      vehicleType: vehicleType,
      position: initialPosition,
      speedKmh: 0.0,
      lastUpdated: DateTime.now(),
    );

    try {
      // Registrar el miembro en la ruta del grupo en Firebase
      await _dio.put(
        '$_dbUrl/$cleanCode/members/$currentMemberId.json',
        data: member.toJson(),
      );
      _startSyncLoop();
      return true;
    } catch (_) {}

    return false;
  }

  // Salir de la caravana activa
  Future<void> leaveCaravan() async {
    if (currentGroupCode != null && currentMemberId != null) {
      try {
        await _dio.delete(
          '$_dbUrl/$currentGroupCode/members/$currentMemberId.json',
        );
      } catch (_) {}
    }
    _syncTimer?.cancel();
    currentGroupCode = null;
    currentMemberId = null;
    _membersController.add([]);
  }

  // Transmitir posición GPS actual a los demás miembros
  Future<void> broadcastPosition(LatLng pos, double speedKmh) async {
    if (currentGroupCode == null || currentMemberId == null) return;

    try {
      await _dio.patch(
        '$_dbUrl/$currentGroupCode/members/$currentMemberId.json',
        data: {
          'lat': pos.latitude,
          'lng': pos.longitude,
          'speedKmh': speedKmh,
          'lastUpdated': DateTime.now().millisecondsSinceEpoch,
        },
      );
    } catch (_) {}
  }

  // Bucle periódico de sincronización de miembros de la caravana
  void _startSyncLoop() {
    _syncTimer?.cancel();
    _fetchMembers();
    _syncTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      _fetchMembers();
    });
  }

  Future<void> _fetchMembers() async {
    if (currentGroupCode == null) return;

    try {
      final res = await _dio.get('$_dbUrl/$currentGroupCode/members.json');
      if (res.statusCode == 200 && res.data is Map) {
        final Map map = res.data;
        final List<CaravanMember> list = [];
        final now = DateTime.now();

        map.forEach((key, val) {
          if (val is Map) {
            final member = CaravanMember.fromJson(key.toString(), val.cast<String, dynamic>());
            // Filtrar miembros activos recientemente (resistente a desfasajes de reloj)
            if (now.difference(member.lastUpdated).inMinutes.abs() < 120) {
              list.add(member);
            }
          }
        });

        _membersController.add(list);
      }
    } catch (_) {}
  }
}
