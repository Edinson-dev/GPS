import 'dart:async';
import 'package:dio/dio.dart';

class GasStationPrice {
  final String stationId;
  final int regularPriceCop;
  final int premiumPriceCop;
  final int dieselPriceCop;
  final DateTime lastUpdated;

  GasStationPrice({
    required this.stationId,
    required this.regularPriceCop,
    required this.premiumPriceCop,
    required this.dieselPriceCop,
    required this.lastUpdated,
  });

  factory GasStationPrice.fromJson(String stationId, Map<String, dynamic> json) {
    return GasStationPrice(
      stationId: stationId,
      regularPriceCop: (json['regularPriceCop'] as num?)?.toInt() ?? 15800,
      premiumPriceCop: (json['premiumPriceCop'] as num?)?.toInt() ?? 20200,
      dieselPriceCop: (json['dieselPriceCop'] as num?)?.toInt() ?? 11500,
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(
        json['lastUpdated'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'regularPriceCop': regularPriceCop,
      'premiumPriceCop': premiumPriceCop,
      'dieselPriceCop': dieselPriceCop,
      'lastUpdated': lastUpdated.millisecondsSinceEpoch,
    };
  }
}

class GasPricesService {
  final Dio _dio = Dio();
  static const String _dbUrl =
      'https://flutter-ai-playground-52ad9-default-rtdb.firebaseio.com/gas_prices';

  final _pricesController = StreamController<Map<String, GasStationPrice>>.broadcast();
  Stream<Map<String, GasStationPrice>> get pricesStream => _pricesController.stream;

  Timer? _syncTimer;

  GasPricesService() {
    startSync();
  }

  void startSync() {
    _fetchPrices();
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _fetchPrices();
    });
  }

  void dispose() {
    _syncTimer?.cancel();
    _pricesController.close();
  }

  Future<void> updatePrice({
    required String stationId,
    required int regularPriceCop,
    required int premiumPriceCop,
    required int dieselPriceCop,
  }) async {
    final gasPrice = GasStationPrice(
      stationId: stationId,
      regularPriceCop: regularPriceCop,
      premiumPriceCop: premiumPriceCop,
      dieselPriceCop: dieselPriceCop,
      lastUpdated: DateTime.now(),
    );

    try {
      await _dio.put(
        '$_dbUrl/$stationId.json',
        data: gasPrice.toJson(),
      );
      _fetchPrices();
    } catch (_) {}
  }

  Future<void> _fetchPrices() async {
    try {
      final res = await _dio.get('$_dbUrl.json');
      if (res.statusCode == 200 && res.data is Map) {
        final Map map = res.data;
        final Map<String, GasStationPrice> priceMap = {};

        map.forEach((key, val) {
          if (val is Map) {
            final price = GasStationPrice.fromJson(key.toString(), val.cast<String, dynamic>());
            priceMap[key.toString()] = price;
          }
        });

        _pricesController.add(priceMap);
      } else {
        _pricesController.add({});
      }
    } catch (_) {
      _pricesController.add({});
    }
  }
}
