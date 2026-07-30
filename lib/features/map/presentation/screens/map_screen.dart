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
import '../../../incidents/models/incident_model.dart';
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
  bool _isSearchingDropdownOpen = false;

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

  void _fitRouteBounds(LatLng origin, LatLng dest, List<LatLng> points) {
    if (points.isEmpty) return;
    try {
      final bounds = LatLngBounds.fromPoints([origin, dest, ...points]);
      _mapController.fitCamera(
        CameraFit.bounds(
          bounds: bounds,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 140),
        ),
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final navState = ref.watch(navigationProvider);
    final navNotifier = ref.read(navigationProvider.notifier);

    // Escuchar cambios en la ruta o ubicación para auto-centrar o encuadrar vista previa de ruta
    ref.listen(navigationProvider, (previous, next) {
      if (next.currentLocation != null && !_hasCenteredInitialPos) {
        _hasCenteredInitialPos = true;
        _mapController.move(next.currentLocation!.position, 16.5);
      }

      if (next.selectedRoute != null && next.destination != null && previous?.selectedRoute != next.selectedRoute) {
        _fitRouteBounds(
          next.currentLocation?.position ?? const LatLng(MapboxConstants.defaultLat, MapboxConstants.defaultLng),
          next.destination!,
          next.selectedRoute!.polylinePoints,
        );
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

    // Extraer puntos de alerta de tráfico pesado o accidentes para dibujar línea roja
    final List<Polyline> trafficLines = [];
    if (navState.selectedRoute != null) {
      final trafficIncidents = navState.activeIncidents.where(
        (inc) => inc.type == IncidentType.trafficJam || inc.type == IncidentType.crash,
      );
      for (final inc in trafficIncidents) {
        // Encontrar segmento de la ruta cercano al incidente
        final routePts = navState.selectedRoute!.polylinePoints;
        for (int i = 0; i < routePts.length - 1; i++) {
          final dist = const Distance().as(LengthUnit.Meter, inc.position, routePts[i]);
          if (dist < 150) {
            final startIdx = (i - 4).clamp(0, routePts.length - 1);
            final endIdx = (i + 4).clamp(0, routePts.length - 1);
            trafficLines.add(
              Polyline(
                points: routePts.sublist(startIdx, endIdx + 1),
                color: const Color(0xFFFF2E55),
                strokeWidth: 9.0,
              ),
            );
            break;
          }
        }
      }
    }

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
                if (navState.selectedRoute != null) ...[
                  PolylineLayer(
                    polylines: [
                      // Línea principal de ruta Waze Neón Cian
                      Polyline(
                        points: navState.selectedRoute!.polylinePoints,
                        color: const Color(0xFF00C8FF),
                        strokeWidth: 8.0,
                      ),
                      // Trazado de segmento rojo para tráfico pesado / accidentes
                      ...trafficLines,
                    ],
                  ),
                ],
                MarkerLayer(
                  markers: [
                    // Marcador GPS estilo Flecha Waze Neón con Rotación Real por Brújula
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
                    // Marcador de Destino Seleccionado
                    if (navState.destination != null)
                      Marker(
                        point: navState.destination!,
                        width: 48,
                        height: 48,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF2E55),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFFF2E55),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.flag_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                    // Marcadores de Incidentes en Vía
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

          // Overlay Superior: Barra de Búsqueda y Selector de Transportes
          Positioned(
            top: topInset,
            left: 12,
            right: 12,
            child: SearchBarOverlay(
              pulsePoints: navState.pulsePoints,
              onPlaceSelected: (pos, name) {
                navNotifier.calculateRoutesTo(pos, name);
              },
              onSearchingStateChanged: (isSearching) {
                setState(() => _isSearchingDropdownOpen = isSearching);
              },
            ),
          ),

          // Overlay Izquierdo: Velocímetro (Se oculta al desplegar lista de búsqueda para no estorbar)
          if (!_isSearchingDropdownOpen)
            Positioned(
              top: topInset + 105,
              left: 12,
              child: SpeedLimitBadge(
                currentSpeedKmh: currentSpeed,
                speedLimitKmh: navState.currentSpeedLimit,
              ),
            ),

          // Overlay Derecho: Controles del Mapa 2D/3D (Se oculta al buscar para no tapar los resultados)
          if (!_isSearchingDropdownOpen)
            Positioned(
              top: topInset + 105,
              right: 12,
              child: MapControlsWidget(
                is3DMode: _is3DMode,
                onToggle3D: () {
                  setState(() => _is3DMode = !_is3DMode);
                  _mapController.rotate(_is3DMode ? 0.0 : 35.0);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_is3DMode ? 'Modo 2D Norte Arriba Activo' : 'Modo 3D Perspectiva Activo'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                onRecenter: () {
                  _mapController.move(currentPos, 16.5);
                  _mapController.rotate(0.0);
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
          if (navState.availableRoutes.isEmpty && !_isSearchingDropdownOpen)
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
                onCancel: () => navNotifier.stopNavigation(),
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
