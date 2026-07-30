import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Paleta de Colores Inspirada en Waze + WayPulse Eco Accent
  static const Color primaryBlue = Color(0xFF00C8FF);
  static const Color darkBackground = Color(0xFF121824);
  static const Color cardDark = Color(0xFF1E293B);
  static const Color alertOrange = Color(0xFFFF6B00);
  static const Color alertRed = Color(0xFFFF2E55);
  static const Color ecoGreen = Color(0xFF00E676);
  static const Color policeBlue = Color(0xFF29B6F6);
  static const Color textLight = Color(0xFFF8FAFC);
  static const Color textMuted = Color(0xFF94A3B8);

  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF0F172A);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      primaryColor: primaryBlue,
      cardColor: cardLight,
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: const TextStyle(color: textDark, fontWeight: FontWeight.bold),
        bodyLarge: const TextStyle(color: textDark),
        bodyMedium: const TextStyle(color: textMuted),
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: ecoGreen,
        surface: cardLight,
        error: alertRed,
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      primaryColor: primaryBlue,
      cardColor: cardDark,
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: const TextStyle(color: textLight, fontWeight: FontWeight.bold),
        bodyLarge: const TextStyle(color: textLight),
        bodyMedium: const TextStyle(color: textMuted),
      ),
      colorScheme: const ColorScheme.dark(
        primary: primaryBlue,
        secondary: ecoGreen,
        surface: cardDark,
        error: alertRed,
      ),
      useMaterial3: true,
    );
  }
}
