import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/medellin_closures_service.dart';
import '../models/medellin_closure_model.dart';

final medellinClosuresServiceProvider = Provider<MedellinClosuresService>((ref) {
  return MedellinClosuresService();
});

final medellinClosuresProvider = FutureProvider<List<MedellinClosure>>((ref) async {
  final service = ref.watch(medellinClosuresServiceProvider);
  return service.fetchAllClosures();
});

/// Estado para alternar la visibilidad de la capa oficial de cierres de Medellín
final medellinClosuresVisibilityProvider = StateProvider<bool>((ref) => true);
