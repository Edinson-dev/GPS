import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/services/mapbox_geocoding_service.dart';

class SearchBarOverlay extends StatefulWidget {
  final int pulsePoints;
  final Function(LatLng position, String name) onPlaceSelected;

  const SearchBarOverlay({
    super.key,
    required this.pulsePoints,
    required this.onPlaceSelected,
  });

  @override
  State<SearchBarOverlay> createState() => _SearchBarOverlayState();
}

class _SearchBarOverlayState extends State<SearchBarOverlay> {
  final MapboxGeocodingService _geocodingService = MapboxGeocodingService();
  final TextEditingController _controller = TextEditingController();
  List<SearchLocationResult> _searchResults = [];
  bool _isLoading = false;

  void _onSearchChanged(String query) async {
    if (query.trim().length < 3) {
      setState(() => _searchResults = []);
      return;
    }

    setState(() => _isLoading = true);
    final results = await _geocodingService.searchPlaces(query);
    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Barra Principal de Búsqueda
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ],
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Row(
            children: [
              const Icon(Icons.search_rounded, color: Color(0xFF00C8FF), size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: _onSearchChanged,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: const InputDecoration(
                    hintText: '¿A dónde quieres ir?',
                    hintStyle: TextStyle(color: Color(0xFF94A3B8)),
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (_isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF00C8FF)),
                )
              else if (_controller.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white70),
                  onPressed: () {
                    _controller.clear();
                    setState(() => _searchResults = []);
                  },
                ),
              // Insignia de PulsePoints Gamificada
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B00).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFF6B00)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt_rounded, color: Color(0xFFFF6B00), size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.pulsePoints} pts',
                      style: const TextStyle(
                        color: Color(0xFFFF6B00),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Lista Desplegable de Resultados
        if (_searchResults.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            constraints: const BoxConstraints(maxHeight: 250),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _searchResults.length,
              separatorBuilder: (_, __) => const Divider(color: Color(0xFF334155), height: 1),
              itemBuilder: (context, index) {
                final item = _searchResults[index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF00C8FF),
                    child: Icon(Icons.location_on_rounded, color: Colors.white, size: 20),
                  ),
                  title: Text(
                    item.title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    item.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                  ),
                  onTap: () {
                    widget.onPlaceSelected(item.position, item.title);
                    _controller.clear();
                    setState(() => _searchResults = []);
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
