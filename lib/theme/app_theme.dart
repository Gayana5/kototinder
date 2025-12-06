import 'package:flutter/material.dart';

class AppTheme {
  static const Color blush = Color(0xFFFFC7C2);
  static const Color mint = Color(0xFF8AD6CC);
  static const Color amber = Color(0xFFFFC857);
  static const Color ink = Color(0xFF2A2D34);
  static const Color background = Color(0xFFF8F5F2);

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFFF8FA3),
      surface: background,
      primary: const Color(0xFFFF8FA3),
      secondary: mint,
    ),
    scaffoldBackgroundColor: background,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: ink,
      centerTitle: true,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: Colors.white.withValues(alpha: 0.9),
      elevation: 6,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        color: ink,
      ),
      bodyMedium: TextStyle(height: 1.4, color: ink),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF8FA3),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  );
}
