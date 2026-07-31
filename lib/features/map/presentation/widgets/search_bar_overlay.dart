import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/services/mapbox_geocoding_service.dart';
import '../../../navigation/providers/navigation_provider.dart';

class SearchBarOverlay extends ConsumerStatefulWidget {
  final int pulsePoints;
  final Function(LatLng position, String name) onPlaceSelected;
  final Function(bool isSearching)? onSearchingStateChanged;

  const SearchBarOverlay({
    super.key,
    required this.pulsePoints,
    required this.onPlaceSelected,
    this.onSearchingStateChanged,
  });

  @override
  ConsumerState<SearchBarOverlay> createState() => _SearchBarOverlayState();
}

class _SearchBarOverlayState extends ConsumerState<SearchBarOverlay> {
  final MapboxGeocodingService _geocodingService = MapboxGeocodingService();
  final TextEditingController _controller = TextEditingController();
  List<SearchLocationResult> _searchResults = [];
  bool _isLoading = false;

  void _onSearchChanged(String query) async {
    if (query.trim().length < 2) {
      setState(() => _searchResults = []);
      widget.onSearchingStateChanged?.call(false);
      return;
    }

    setState(() => _isLoading = true);
    final userPos = ref.read(navigationProvider).currentLocation?.position;
    final results = await _geocodingService.searchPlaces(query, proximity: userPos);
    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
    widget.onSearchingStateChanged?.call(_searchResults.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final navState = ref.watch(navigationProvider);
    final navNotifier = ref.read(navigationProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Selector de Transportes (Auto, Moto, Bici, Caminando, Bus)
        Container(
          height: 40,
          margin: const EdgeInsets.only(bottom: 8),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildTransportChip(
                mode: TransportMode.car,
                icon: Icons.directions_car_rounded,
                label: 'Auto',
                selectedMode: navState.selectedTransportMode,
                onSelect: (m) => navNotifier.setTransportMode(m),
              ),
              _buildTransportChip(
                mode: TransportMode.moto,
                icon: Icons.two_wheeler_rounded,
                label: 'Moto',
                selectedMode: navState.selectedTransportMode,
                onSelect: (m) => navNotifier.setTransportMode(m),
              ),
              _buildTransportChip(
                mode: TransportMode.bike,
                icon: Icons.pedal_bike_rounded,
                label: 'Bici',
                selectedMode: navState.selectedTransportMode,
                onSelect: (m) => navNotifier.setTransportMode(m),
              ),
              _buildTransportChip(
                mode: TransportMode.walk,
                icon: Icons.directions_walk_rounded,
                label: 'A pie',
                selectedMode: navState.selectedTransportMode,
                onSelect: (m) => navNotifier.setTransportMode(m),
              ),
              _buildTransportChip(
                mode: TransportMode.transit,
                icon: Icons.directions_bus_rounded,
                label: 'Bus',
                selectedMode: navState.selectedTransportMode,
                onSelect: (m) => navNotifier.setTransportMode(m),
              ),
            ],
          ),
        ),

        // Barra Principal de Búsqueda Estilo Glassmorphism Cristal Neón
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00C8FF).withValues(alpha: 0.25),
                blurRadius: 18,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ],
            border: Border.all(color: const Color(0xFF00C8FF).withValues(alpha: 0.6), width: 1.5),
          ),
          child: Row(
            children: [
              const Icon(Icons.search_rounded, color: Color(0xFF00C8FF), size: 26),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: _onSearchChanged,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (query) {
                    if (_searchResults.isNotEmpty) {
                      final first = _searchResults.first;
                      FocusScope.of(context).unfocus();
                      widget.onPlaceSelected(first.position, first.title);
                      _controller.clear();
                      setState(() => _searchResults = []);
                      widget.onSearchingStateChanged?.call(false);
                    }
                  },
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: const InputDecoration(
                    hintText: '¿A dónde quieres ir? (Dirección exacta)',
                    hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (_isLoading)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF00C8FF)),
                )
              else if (_controller.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 20),
                  onPressed: () {
                    _controller.clear();
                    setState(() => _searchResults = []);
                    widget.onSearchingStateChanged?.call(false);
                  },
                ),
              // Insignia de PulsePoints Gamificada
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B00).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFF6B00)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt_rounded, color: Color(0xFFFF6B00), size: 14),
                    const SizedBox(width: 2),
                    Text(
                      '${widget.pulsePoints} pts',
                      style: const TextStyle(
                        color: Color(0xFFFF6B00),
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Lista Desplegable de Resultados con Direcciones Exactas (sin CP)
        if (_searchResults.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            constraints: const BoxConstraints(maxHeight: 240),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Material(
              color: Colors.transparent,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _searchResults.length,
                separatorBuilder: (_, __) => const Divider(color: Color(0xFF334155), height: 1),
                itemBuilder: (context, index) {
                  final item = _searchResults[index];
                  return ListTile(
                    dense: true,
                    leading: const CircleAvatar(
                      radius: 16,
                      backgroundColor: Color(0xFF00C8FF),
                      child: Icon(Icons.location_on_rounded, color: Colors.white, size: 18),
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Text(
                      item.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                    ),
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      widget.onPlaceSelected(item.position, item.title);
                      _controller.clear();
                      setState(() => _searchResults = []);
                      widget.onSearchingStateChanged?.call(false);
                    },
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTransportChip({
    required TransportMode mode,
    required IconData icon,
    required String label,
    required TransportMode selectedMode,
    required Function(TransportMode) onSelect,
  }) {
    final isSelected = mode == selectedMode;
    return GestureDetector(
      onTap: () => onSelect(mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00C8FF) : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF00C8FF) : const Color(0xFF334155),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF00C8FF).withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.black : Colors.white70,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
