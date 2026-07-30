import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;
import '../../../../core/constants/mapbox_constants.dart';
import '../../../navigation/providers/navigation_provider.dart';
import '../../../navigation/presentation/screens/navigation_mode_screen.dart';
import '../widgets/speed_limit_badge.dart';
import '../widgets/map_controls.dart';
import '../widgets/search_bar_overlay.dart';
import '../../../incidents/presentation/widgets/incident_fab_button.dart';
import '../../../incidents/presentation/widgets/report_incident_modal.dart';
import '../../../eco_route/presentation/widgets/route_selector_sheet.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  late final MapController _mapController;
  bool _is3DMode = true;
  int _styleIndex = 0;
  bool _hasCenteredInitialPos = false;

  final List<String> _tileStyles = [
    'https://basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/256/{z}/{x}/{y}?access_token=${MapboxConstants.publicToken}',
  ];

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

    // Auto-centrar en la ubicación GPS real del usuario cuando se recibe por primera vez
    ref.listen(navigationProvider, (previous, next) {
      if (next.currentLocation != null && !_hasCenteredInitialPos) {
        _hasCenteredInitialPos = true;
        _mapController.move(next.currentLocation!.position, 16.5);
      }
    });

    if (navState.isNavigating) {
      return const NavigationModeScreen();
    }

    final currentPos = navState.currentLocation?.position ??
        const LatLng(MapboxConstants.defaultLat, MapboxConstants.defaultLng);
    final currentSpeed = navState.currentLocation?.speedKmh ?? 0.0;
    final currentHeading = (navState.currentLocation?.heading ?? 0.0) * (3.141592653589793 / 180.0);

    final topInset = MediaQuery.of(context).padding.top + 10;

    return Scaffold(
      body: Stack(
        children: [
          // Capa de Mapa Mosaicos Waze Light Ultra-Rápidos
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: currentPos,
                initialZoom: 16.5,
              ),
              children: [
                TileLayer(
                  urlTemplate: _tileStyles[_styleIndex],
                  userAgentPackageName: 'com.waypulse.waypulse_app',
                  maxZoom: 19,
                ),
                if (navState.selectedRoute != null)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: navState.selectedRoute!.polylinePoints,
                        color: const Color(0xFF00C8FF),
                        strokeWidth: 7.0,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    // Marcador GPS estilo Flecha Waze Neón con Rotación Real por Brujula/Heading
                    Marker(
                      point: currentPos,
                      width: 54,
                      height: 54,
                      child: Transform.rotate(
                        angle: currentHeading,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFF00C8FF).withOpacity(0.3),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF00C8FF).withOpacity(0.6),
                                    blurRadius: 18,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 38,
                              height: 38,
                              decoration: const BoxDecoration(
                                color: Color(0xFF00C8FF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.navigation,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ...navState.activeIncidents.map(
                      (inc) => Marker(
                        point: inc.position,
                        width: 38,
                        height: 38,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF2E55),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFFF2E55),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Overlay Superior: Barra de Búsqueda y Selector de Transportes (Con Padding Seguro de Notch)
          Positioned(
            top: topInset,
            left: 12,
            right: 12,
            child: SearchBarOverlay(
              pulsePoints: navState.pulsePoints,
              onPlaceSelected: (pos, name) {
                navNotifier.calculateRoutesTo(pos, name);
              },
            ),
          ),

          // Overlay Izquierdo: Velocímetro
          Positioned(
            top: topInset + 105,
            left: 12,
            child: SpeedLimitBadge(
              currentSpeedKmh: currentSpeed,
              speedLimitKmh: navState.currentSpeedLimit,
            ),
          ),

          // Overlay Derecho: Controles del Mapa
          Positioned(
            top: topInset + 105,
            right: 12,
            child: MapControlsWidget(
              is3DMode: _is3DMode,
              onToggle3D: () => setState(() => _is3DMode = !_is3DMode),
              onRecenter: () {
                _mapController.move(currentPos, 16.5);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Recentrado en tu ubicación GPS actual'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              onToggleLayers: () {
                setState(() {
                  _styleIndex = (_styleIndex + 1) % _tileStyles.length;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Capa de mapa cambiada a estilo ${_styleIndex == 0 ? "Waze Light" : _styleIndex == 1 ? "OpenStreet" : "Mapbox HD"}'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          ),

          // Overlay Inferior Central: Botón FAB de Reporte de Alertas Waze
          if (navState.availableRoutes.isEmpty)
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
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
            ),

          // Overlay Inferior Deslizable: Selector de Rutas Eco vs Rápidas
          if (navState.availableRoutes.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: RouteSelectorSheet(
                routes: navState.availableRoutes,
                selectedRoute: navState.selectedRoute,
                onSelect: (route) => navNotifier.selectRoute(route),
                onStartNavigation: () => navNotifier.startNavigation(),
              ),
            ),
        ],
      ),
    );
  }
}

/// CustomPainter para la renderización de la red del mapa, cuadrículas de avenidas y trazado de rutas
class MapGridPainter extends CustomPainter {
  final LatLng userPosition;
  final List routes;
  final dynamic selectedRoute;
  final List incidents;
  final bool is3D;

  MapGridPainter({
    required this.userPosition,
    required this.routes,
    required this.selectedRoute,
    required this.incidents,
    required this.is3D,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Fondo oscuro con rejilla estética de ciudad
    final gridPaint = Paint()
      ..color = const Color(0xFF1E293B).withOpacity(0.5)
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    // Dibujo de avenidas principales
    final roadPaint = Paint()
      ..color = const Color(0xFF334155)
      ..strokeWidth = 14.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), roadPaint);
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), roadPaint);

    // Si hay una ruta seleccionada, dibujamos la línea brillante de dirección Mapbox Neon
    if (selectedRoute != null) {
      final routePaint = Paint()
        ..color = const Color(0xFF00C8FF)
        ..strokeWidth = 8.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final path = Path();
      path.moveTo(center.dx, center.dy);
      path.quadraticBezierTo(
        center.dx + 80,
        center.dy - 120,
        center.dx + 120,
        center.dy - 250,
      );

      canvas.drawPath(path, routePaint);
    }

    // Dibujo del marcador del auto del usuario en el centro (Icono estilo Waze)
    final carPaint = Paint()..color = const Color(0xFF00C8FF);
    final glowPaint = Paint()
      ..color = const Color(0xFF00C8FF).withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    canvas.drawCircle(center, 22, glowPaint);
    canvas.drawCircle(center, 12, carPaint);
    canvas.drawCircle(center, 6, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
