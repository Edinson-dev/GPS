import '../../../../core/services/mapbox_directions_service.dart';

class RouteOption {
  final MapboxRoute route;
  final double co2SavedKg;
  final double batteryEfficiencyPercent;

  RouteOption({
    required this.route,
    required this.co2SavedKg,
    required this.batteryEfficiencyPercent,
  });
}
