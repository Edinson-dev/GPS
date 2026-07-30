class DistanceFormatter {
  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    } else {
      final km = meters / 1000;
      return '${km.toStringAsFixed(1)} km';
    }
  }

  static String formatDuration(double seconds) {
    final minutes = (seconds / 60).round();
    if (minutes < 60) {
      return '$minutes min';
    } else {
      final hours = minutes ~/ 60;
      final remainingMins = minutes % 60;
      return remainingMins > 0 ? '${hours}h ${remainingMins}m' : '${hours}h';
    }
  }

  static String calculateETA(double remainingSeconds) {
    final now = DateTime.now();
    final etaTime = now.add(Duration(seconds: remainingSeconds.round()));
    final hour = etaTime.hour.toString().padLeft(2, '0');
    final minute = etaTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
