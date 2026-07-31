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

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navState = ref.watch(navigationProvider);
    final navNotifier = ref.read(navigationProvider.notifier);

    // Escuchar cambios de posición y rumbo para centrar y orientar la cámara en vivo
    ref.listen(navigationProvider, (previous, next) {
      if (next.currentLocation != null) {
        final pos = next.currentLocation!.position;
        final heading = next.currentLocation!.heading;
        
        // Mover cámara al vehículo
        _mapController.move(pos, _mapController.camera.zoom);
        
        // Rotar cámara hacia la dirección de movimiento si se tiene rumbo válido
        if (heading != 0.0) {
          _mapController.rotate(heading);
        }
      }
    });

    final route = navState.selectedRoute;
    final currentStep = (route != null && navState.currentStepIndex < route.steps.length)
        ? route.steps[navState.currentStepIndex]
        : null;

    final currentSpeed = navState.currentLocation?.speedKmh ?? 0.0;
    final currentPos = navState.currentLocation?.position ??
        const LatLng(MapboxConstants.defaultLat, MapboxConstants.defaultLng);

    final topInset = MediaQuery.of(context).padding.top + 10;

    return Scaffold(
      body: Stack(
        children: [
          // Visor de Navegación 3D Mapbox Night
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: currentPos,
                initialZoom: 17.0,
              ),
              children: [
                TileLayer(
                  key: const ValueKey('waze_nav_permanent_tile_layer'),
                  urlTemplate:
                      'https://basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.waypulse.waypulse_app',
                  tileProvider: NetworkTileProvider(),
                  maxZoom: 19,
                  keepBuffer: 8,
                  tileDisplay: const TileDisplay.fadeIn(duration: Duration(milliseconds: 0)),
                ),
                if (route != null)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: route.polylinePoints,
                        color: const Color(0xFF00C8FF),
                        strokeWidth: 8.0,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: currentPos,
                      width: 50,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF00C8FF),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00C8FF).withOpacity(0.6),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.navigation,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Banner Superior: Próxima Maniobra e Instrucción por Voz (Safe Inset)
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

class Navigation3DPainter extends CustomPainter {
  final double heading;

  Navigation3DPainter({required this.heading});

  @override
  void paint(Canvas canvas, Size size) {
    final bottomCenter = Offset(size.width / 2, size.height * 0.85);
    final horizonCenter = Offset(size.width / 2, size.height * 0.35);

    // Degradado del horizonte nocturno estilo Mapbox Navigation Night
    final bgGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: const [Color(0xFF0B132B), Color(0xFF1C2541), Color(0xFF0B132B)],
    );

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, Paint()..shader = bgGradient.createShader(rect));

    // Perspectiva de Calzada 3D
    final roadPath = Path()
      ..moveTo(horizonCenter.dx - 30, horizonCenter.dy)
      ..lineTo(horizonCenter.dx + 30, horizonCenter.dy)
      ..lineTo(bottomCenter.dx + 160, size.height)
      ..lineTo(bottomCenter.dx - 160, size.height)
      ..close();

    final roadPaint = Paint()..color = const Color(0xFF1E293B);
    canvas.drawPath(roadPath, roadPaint);

    // Trazado Neón de Ruta Activa
    final routePath = Path()
      ..moveTo(horizonCenter.dx, horizonCenter.dy + 20)
      ..lineTo(bottomCenter.dx, bottomCenter.dy);

    final routePaint = Paint()
      ..color = const Color(0xFF00C8FF)
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawPath(routePath, routePaint);

    // Indicador 3D del Vehículo (Puntero estilo Waze Arrow)
    final arrowPath = Path()
      ..moveTo(bottomCenter.dx, bottomCenter.dy - 20)
      ..lineTo(bottomCenter.dx - 15, bottomCenter.dy + 15)
      ..lineTo(bottomCenter.dx, bottomCenter.dy + 8)
      ..lineTo(bottomCenter.dx + 15, bottomCenter.dy + 15)
      ..close();

    canvas.drawPath(arrowPath, Paint()..color = Colors.white);
    canvas.drawPath(
      arrowPath,
      Paint()
        ..color = const Color(0xFF00C8FF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
