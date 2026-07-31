import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart' hide Path;
import '../../../../core/constants/mapbox_constants.dart';
import 'package:waypulse_app/features/navigation/providers/navigation_provider.dart';
import '../widgets/turn_instruction_banner.dart';
import '../widgets/eta_bottom_bar.dart';
import 'package:waypulse_app/features/map/presentation/widgets/speed_limit_badge.dart';
import '../../../incidents/presentation/widgets/incident_fab_button.dart';
import '../../../incidents/presentation/widgets/report_incident_modal.dart';

class NavigationModeScreen extends ConsumerStatefulWidget {
  const NavigationModeScreen({super.key});

  @override
  ConsumerState<NavigationModeScreen> createState() => _NavigationModeScreenState();
}

class _NavigationModeScreenState extends ConsumerState<NavigationModeScreen> {
  late final MapController _mapController;
  bool _isFollowingGps = true;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  void _recenterGps(LatLng currentPos) {
    setState(() {
      _isFollowingGps = true;
    });
    _mapController.move(currentPos, 18.5);
  }

  @override
  Widget build(BuildContext context) {
    final navState = ref.watch(navigationProvider);
    final navNotifier = ref.read(navigationProvider.notifier);

    final route = navState.selectedRoute;
    final currentStep = (route != null && navState.currentStepIndex < route.steps.length)
        ? route.steps[navState.currentStepIndex]
        : null;

    final currentSpeed = navState.currentLocation?.speedKmh ?? 0.0;
    final currentPos = navState.currentLocation?.position ??
        const LatLng(MapboxConstants.defaultLat, MapboxConstants.defaultLng);
    final currentHeading = (navState.currentLocation?.heading ?? 0.0) * (3.141592653589793 / 180.0);

    final topInset = MediaQuery.of(context).padding.top + 10;

    // Escuchar movimiento continuo del GPS para actualizar posición del vehículo en tiempo real
    ref.listen(navigationProvider, (previous, next) {
      if (_isFollowingGps && next.currentLocation != null) {
        if (previous?.currentLocation?.position != next.currentLocation?.position) {
          _mapController.move(next.currentLocation!.position, _mapController.camera.zoom);
        }
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          // Visor de Navegación 3D en Perspectiva Cercana (Zoom 18.5)
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: currentPos,
                initialZoom: 18.5,
                onPositionChanged: (position, hasGesture) {
                  if (hasGesture && _isFollowingGps) {
                    setState(() {
                      _isFollowingGps = false;
                    });
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.waypulse.waypulse_app',
                  tileProvider: CancellableNetworkTileProvider(),
                  maxZoom: 19,
                  keepBuffer: 4,
                ),
                if (route != null)
                  PolylineLayer(
                    polylines: [
                      // Línea neón cian 3D trazando la ruta
                      Polyline(
                        points: route.polylinePoints,
                        color: const Color(0xFF00C8FF),
                        strokeWidth: 10.0,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    // Puntero Navegador 3D con Rotación por Brújula
                    Marker(
                      point: currentPos,
                      width: 58,
                      height: 58,
                      child: Transform.rotate(
                        angle: currentHeading,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                color: const Color(0xFF00C8FF).withOpacity(0.35),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF00C8FF).withOpacity(0.8),
                                    blurRadius: 20,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 42,
                              height: 42,
                              decoration: const BoxDecoration(
                                color: Color(0xFF0F172A),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.navigation_rounded,
                                color: Color(0xFF00C8FF),
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Banner Superior: Próxima Maniobra e Instrucción por Voz
          Positioned(
            top: topInset,
            left: 12,
            right: 12,
            child: TurnInstructionBanner(currentStep: currentStep),
          ),

          // Lado Izquierdo: Velocímetro
          Positioned(
            top: topInset + 105,
            left: 12,
            child: SpeedLimitBadge(
              currentSpeedKmh: currentSpeed,
              speedLimitKmh: navState.currentSpeedLimit,
            ),
          ),

          // Lado Derecho: Botón Flotante "Centrar GPS"
          Positioned(
            bottom: 180,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'recenter_gps_nav_fab',
              onPressed: () => _recenterGps(currentPos),
              backgroundColor: _isFollowingGps ? const Color(0xFF00C8FF) : const Color(0xFF1E293B),
              elevation: 6,
              child: Icon(
                _isFollowingGps ? Icons.gps_fixed_rounded : Icons.gps_not_fixed_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),

          // Lado Derecho: Reporte de Alertas en Ruta
          Positioned(
            bottom: 110,
            right: 16,
            child: IncidentFabButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) => ReportIncidentModal(
                    onReport: (type, desc) {
                      navNotifier.reportIncident(type, desc);
                    },
                  ),
                );
              },
            ),
          ),

          // Barra Inferior: ETA, Tiempos, Distancia y Finalizar Navegación
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ETABottomBar(
              durationSeconds: route?.durationSeconds ?? 0.0,
              distanceMeters: route?.distanceMeters ?? 0.0,
              destinationName: navState.destinationName,
              onStopNavigation: () => navNotifier.stopNavigation(),
            ),
          ),
        ],
      ),
    );
  }
}
