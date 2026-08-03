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
import '../widgets/lane_guidance_widget.dart';
import '../widgets/trip_summary_dialog.dart';

import 'dart:async';
import '../../../../core/services/tts_voice_service.dart';
import '../widgets/route_progress_bar_widget.dart';

class NavigationModeScreen extends ConsumerStatefulWidget {
  const NavigationModeScreen({super.key});

  @override
  ConsumerState<NavigationModeScreen> createState() => _NavigationModeScreenState();
}

class _NavigationModeScreenState extends ConsumerState<NavigationModeScreen> {
  late final MapController _mapController;
  bool _isFollowingGps = true;
  Timer? _autoRecenterTimer;
  final TtsVoiceService _ttsService = TtsVoiceService();
  int _lastSpokenStepIndex = -1;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _autoRecenterTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  void _onUserGesture() {
    if (_isFollowingGps) {
      setState(() {
        _isFollowingGps = false;
      });
    }
    _autoRecenterTimer?.cancel();
    _autoRecenterTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isFollowingGps = true;
        });
      }
    });
  }

  void _recenterGps(LatLng currentPos, double heading) {
    _autoRecenterTimer?.cancel();
    setState(() {
      _isFollowingGps = true;
    });
    _mapController.move(currentPos, 17.8);
    _mapController.rotate(-heading);
  }

  @override
  Widget build(BuildContext context) {
    final navState = ref.watch(navigationProvider);
    final navNotifier = ref.read(navigationProvider.notifier);

    final route = navState.selectedRoute;
    final currentStepIndex = navState.currentStepIndex;
    final currentStep = (route != null && currentStepIndex < route.steps.length)
        ? route.steps[currentStepIndex]
        : null;
    final nextStep = (route != null && (currentStepIndex + 1) < route.steps.length)
        ? route.steps[currentStepIndex + 1]
        : null;

    // Dictado por Voz Inteligente TTS de Instrucción de Giro
    if (currentStepIndex != _lastSpokenStepIndex && currentStep != null) {
      _lastSpokenStepIndex = currentStepIndex;
      _ttsService.speakInstruction('En ${currentStep.distanceMeters.toInt()} metros, ${currentStep.instruction}');
    }

    final currentSpeed = navState.currentLocation?.speedKmh ?? 0.0;
    final currentPos = navState.currentLocation?.position ??
        const LatLng(MapboxConstants.defaultLat, MapboxConstants.defaultLng);
    final rawHeading = navState.currentLocation?.heading ?? 0.0;
    final currentHeadingRad = rawHeading * (3.141592653589793 / 180.0);

    final topInset = MediaQuery.of(context).padding.top + 10;

    // Escuchar movimiento continuo del GPS para actualizar cámara en orientación Heading-Up (TomTom 3D)
    ref.listen(navigationProvider, (previous, next) {
      if (_isFollowingGps && next.currentLocation != null) {
        _mapController.move(next.currentLocation!.position, _mapController.camera.zoom);
        _mapController.rotate(-(next.currentLocation!.heading));
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          // Visor de Navegación 3D en Perspectiva TomTom GO (Zoom 18.5 Heading-Up)
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: currentPos,
                initialZoom: 17.8,
                maxZoom: 18.5,
                minZoom: 3.0,
                initialRotation: -rawHeading,
                onPositionChanged: (position, hasGesture) {
                  if (hasGesture) {
                    _onUserGesture();
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                  fallbackUrl: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.waypulse.waypulse_app',
                  tileProvider: CancellableNetworkTileProvider(),
                  maxZoom: 19,
                  maxNativeZoom: 18,
                  keepBuffer: 2,
                  panBuffer: 1,
                  tileDisplay: const TileDisplay.fadeIn(duration: Duration(milliseconds: 100)),
                ),
                if (route != null)
                  PolylineLayer(
                    polylines: [
                      // Línea principal de ruta TomTom Azul Neón
                      Polyline(
                        points: route.polylinePoints,
                        color: const Color(0xFF0070F3),
                        strokeWidth: 11.0,
                      ),
                      // Tramo de tráfico activo en verde sobre la ruta libre
                      Polyline(
                        points: route.polylinePoints,
                        color: const Color(0xFF10B981),
                        strokeWidth: 4.0,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    // Puntero Chevron 3D TomTom Azul Eléctrico con Sombra de Profundidad
                    Marker(
                      point: currentPos,
                      width: 64,
                      height: 64,
                      child: Transform.rotate(
                        angle: _isFollowingGps ? 0.0 : currentHeadingRad,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: (currentSpeed > navState.currentSpeedLimit ? const Color(0xFFFF2E55) : const Color(0xFF00C8FF)).withValues(alpha: 0.25),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: (currentSpeed > navState.currentSpeedLimit ? const Color(0xFFFF2E55) : const Color(0xFF00C8FF)).withValues(alpha: 0.7),
                                    blurRadius: 24,
                                    spreadRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.navigation_rounded,
                              color: Color(0xFF00C8FF),
                              size: 44,
                            ),
                            const Icon(
                              Icons.navigation_rounded,
                              color: Colors.white,
                              size: 34,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Marcador de Destino Final Iluminado Neón
                    if (navState.destination != null)
                      Marker(
                        point: navState.destination!,
                        width: 52,
                        height: 52,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF2E55),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF2E55).withValues(alpha: 0.6),
                                blurRadius: 18,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.flag_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Lado Derecho: Barra Vertical de Progreso de Ruta (Estímulo Tráfico y Retenes)
          if (route != null)
            Positioned(
              top: topInset + 160,
              right: 16,
              child: RouteProgressBarWidget(
                route: route,
                currentStepIndex: navState.currentStepIndex,
                currentSpeedKmh: currentSpeed,
              ),
            ),

          // Banner Superior TomTom: Maniobra Actual y Sub-Banner "Luego en..."
          Positioned(
            top: topInset,
            left: 12,
            right: 12,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TurnInstructionBanner(
                  currentStep: currentStep,
                  nextStep: nextStep,
                ),
                const SizedBox(height: 6),
                LaneGuidanceWidget(
                  totalLanes: 4,
                  activeLaneIndex: 1,
                  nextManeuverText: currentStep?.instruction ?? 'Mantén el carril central',
                ),
              ],
            ),
          ),

          // Lado Izquierdo: Velocímetro Estilo TomTom
          Positioned(
            top: topInset + (nextStep != null ? 210 : 170),
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
              onPressed: () => _recenterGps(currentPos, rawHeading),
              backgroundColor: _isFollowingGps ? const Color(0xFF0070F3) : const Color(0xFF1E293B),
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

          // Barra Inferior: ETA, Tiempos, Distancia y Finalizar Navegación (TomTom Clean White Card)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ETABottomBar(
              durationSeconds: route?.durationSeconds ?? 0.0,
              distanceMeters: route?.distanceMeters ?? 0.0,
              destinationName: navState.destinationName,
              onStopNavigation: () {
                final distKm = (route?.distanceMeters ?? 0) / 1000.0;
                final durationMin = ((route?.durationSeconds ?? 0) / 60.0).round();
                final destName = navState.destinationName;

                navNotifier.stopNavigation();

                showDialog(
                  context: context,
                  builder: (ctx) => TripSummaryDialog(
                    destinationName: destName,
                    distanceKm: distKm,
                    durationMinutes: durationMin,
                    onClose: () => Navigator.pop(ctx),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
