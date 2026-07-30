import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_theme.dart';
import 'config/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: WayPulseApp(),
    ),
  );
}

class WayPulseApp extends StatelessWidget {
  const WayPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WayPulse Navigation',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
