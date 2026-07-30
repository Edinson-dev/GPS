import 'package:flutter/material.dart';
import '../features/splash/presentation/screens/splash_screen.dart';
import '../features/map/presentation/screens/map_screen.dart';
import '../features/navigation/presentation/screens/navigation_mode_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String map = '/map';
  static const String navigation = '/navigation';

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        map: (context) => const MapScreen(),
        navigation: (context) => const NavigationModeScreen(),
      };
}
