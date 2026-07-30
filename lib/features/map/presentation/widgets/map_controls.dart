import 'package:flutter/material.dart';

class MapControlsWidget extends StatelessWidget {
  final VoidCallback onRecenter;
  final VoidCallback onToggle3D;
  final bool is3DMode;
  final VoidCallback onToggleLayers;
  final VoidCallback? onToggleTraffic;
  final bool isTrafficActive;

  const MapControlsWidget({
    super.key,
    required this.onRecenter,
    required this.onToggle3D,
    required this.is3DMode,
    required this.onToggleLayers,
    this.onToggleTraffic,
    this.isTrafficActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCircularButton(
          icon: is3DMode ? Icons.view_in_ar_rounded : Icons.map_rounded,
          label: is3DMode ? '3D' : '2D',
          onPressed: onToggle3D,
          isActive: is3DMode,
        ),
        const SizedBox(height: 10),
        if (onToggleTraffic != null) ...[
          _buildCircularButton(
            icon: Icons.traffic_rounded,
            onPressed: onToggleTraffic!,
            isActive: isTrafficActive,
            color: isTrafficActive ? const Color(0xFFFF6B00) : const Color(0xFF1E293B),
          ),
          const SizedBox(height: 10),
        ],
        _buildCircularButton(
          icon: Icons.layers_rounded,
          onPressed: onToggleLayers,
        ),
        const SizedBox(height: 10),
        _buildCircularButton(
          icon: Icons.my_location_rounded,
          color: const Color(0xFF00C8FF),
          iconColor: Colors.white,
          onPressed: onRecenter,
        ),
      ],
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    String? label,
    required VoidCallback onPressed,
    Color? color,
    Color? iconColor,
    bool isActive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color ?? (isActive ? const Color(0xFF00C8FF) : const Color(0xFF1E293B)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Center(
            child: label != null
                ? Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  )
                : Icon(
                    icon,
                    color: iconColor ?? Colors.white,
                    size: 24,
                  ),
          ),
        ),
      ),
    );
  }
}
