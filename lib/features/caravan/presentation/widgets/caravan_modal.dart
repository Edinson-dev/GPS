import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/services/caravan_service.dart';

class CaravanModal extends StatefulWidget {
  final CaravanService caravanService;
  final LatLng currentPos;
  final VoidCallback onStateChanged;

  const CaravanModal({
    super.key,
    required this.caravanService,
    required this.currentPos,
    required this.onStateChanged,
  });

  @override
  State<CaravanModal> createState() => _CaravanModalState();
}

class _CaravanModalState extends State<CaravanModal> {
  final _nameController = TextEditingController(text: 'Conductor');
  final _codeController = TextEditingController();
  String _vehicleType = 'car'; // 'car' o 'bike'
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final activeCode = widget.caravanService.currentGroupCode;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // Encabezado
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF8B5CF6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.groups_rounded, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '👥 Caravana & Rodada en Grupo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rastrea a tus amigos en vivo en la vía',
                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (activeCode != null) ...[
              // Caravana Activa
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFF8B5CF6), width: 1.5),
                ),
                child: Column(
                  children: [
                    const Text(
                      'CÓDIGO DE CARAVANA ACTIVA',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          activeCode,
                          style: const TextStyle(
                            color: Color(0xFF8B5CF6),
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, color: Colors.white70),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: activeCode));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Código copiado al portapapeles 📋')),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await widget.caravanService.leaveCaravan();
                        widget.onStateChanged();
                        if (mounted) Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        minimumSize: const Size(double.infinity, 46),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.exit_to_app_rounded, color: Colors.white),
                      label: const Text('Salir de la Caravana', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Formulario de Crear o Unirse
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Tu Nombre o Apodo',
                  labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  prefixIcon: const Icon(Icons.person_rounded, color: Color(0xFF8B5CF6)),
                ),
              ),
              const SizedBox(height: 14),

              // Selector Tipo de Vehículo
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.directions_car_rounded, size: 18),
                          SizedBox(width: 6),
                          Text('Carro'),
                        ],
                      ),
                      selected: _vehicleType == 'car',
                      onSelected: (val) => setState(() => _vehicleType = 'car'),
                      selectedColor: const Color(0xFF8B5CF6),
                      backgroundColor: const Color(0xFF1E293B),
                      labelStyle: TextStyle(color: _vehicleType == 'car' ? Colors.white : Colors.white70),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ChoiceChip(
                      label: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.two_wheeler_rounded, size: 18),
                          SizedBox(width: 6),
                          Text('Moto'),
                        ],
                      ),
                      selected: _vehicleType == 'bike',
                      onSelected: (val) => setState(() => _vehicleType = 'bike'),
                      selectedColor: const Color(0xFF8B5CF6),
                      backgroundColor: const Color(0xFF1E293B),
                      labelStyle: TextStyle(color: _vehicleType == 'bike' ? Colors.white : Colors.white70),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Botón Crear Caravana
              ElevatedButton.icon(
                onPressed: _isLoading
                    ? null
                    : () async {
                        setState(() => _isLoading = true);
                        await widget.caravanService.createCaravan(
                          nickname: _nameController.text,
                          vehicleType: _vehicleType,
                          initialPosition: widget.currentPos,
                        );
                        widget.onStateChanged();
                        if (mounted) Navigator.pop(context);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.add_circle_rounded, color: Colors.white),
                label: const Text(
                  'Crear Nueva Caravana',
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('— O ÚNETE A UNA EXISTENTE —', style: TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.bold)),
              ),

              // Campo de Código
              TextField(
                controller: _codeController,
                textCapitalization: TextCapitalization.characters,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                decoration: InputDecoration(
                  hintText: 'CÓDIGO (ej: RODADA-1234)',
                  hintStyle: const TextStyle(color: Color(0xFF64748B)),
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  prefixIcon: const Icon(Icons.qr_code_rounded, color: Color(0xFF8B5CF6)),
                ),
              ),
              const SizedBox(height: 12),

              OutlinedButton.icon(
                onPressed: _isLoading
                    ? null
                    : () async {
                        final code = _codeController.text.trim();
                        if (code.isEmpty) return;

                        setState(() => _isLoading = true);
                        final ok = await widget.caravanService.joinCaravan(
                          code: code,
                          nickname: _nameController.text,
                          vehicleType: _vehicleType,
                          initialPosition: widget.currentPos,
                        );
                        setState(() => _isLoading = false);

                        if (ok) {
                          widget.onStateChanged();
                          if (mounted) Navigator.pop(context);
                        } else {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Caravana no encontrada. Revisa el código.')),
                            );
                          }
                        }
                      },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF8B5CF6), width: 1.5),
                  minimumSize: const Size(double.infinity, 46),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.login_rounded, color: Color(0xFF8B5CF6)),
                label: const Text('Unirme con Código', style: TextStyle(color: Color(0xFF8B5CF6), fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
