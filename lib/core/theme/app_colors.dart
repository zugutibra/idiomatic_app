import 'package:flutter/material.dart';

/// Color tokens lifted directly from the Idiomatic design (Idiomatic.dc.html
/// `LIGHT` / `DARK` theme objects) so the Flutter app matches pixel-for-pixel.
class AppColors {
  const AppColors({
    required this.bg,
    required this.surface,
    required this.surfaceAlt,
    required this.border,
    required this.text,
    required this.textSecondary,
    required this.textTertiary,
    required this.primary,
    required this.primaryDark,
    required this.primarySoft,
    required this.onPrimary,
    required this.onPrimarySoft,
    required this.success,
    required this.successSoft,
    required this.warn,
    required this.warnSoft,
    required this.danger,
    required this.dangerSoft,
  });

  final Color bg;
  final Color surface;
  final Color surfaceAlt;
  final Color border;
  final Color text;
  final Color textSecondary;
  final Color textTertiary;
  final Color primary;
  final Color primaryDark;
  final Color primarySoft;
  final Color onPrimary;
  final Color onPrimarySoft;
  final Color success;
  final Color successSoft;
  final Color warn;
  final Color warnSoft;
  final Color danger;
  final Color dangerSoft;

  static const light = AppColors(
    bg: Color(0xFFFBF7EF),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFF1EBDD),
    border: Color(0xFFE6DFCF),
    text: Color(0xFF221F1A),
    textSecondary: Color(0xFF6E695C),
    textTertiary: Color(0xFFA19B8C),
    primary: Color(0xFF2F6F62),
    primaryDark: Color(0xFF1F4E44),
    primarySoft: Color(0xFFE1EEE9),
    onPrimary: Color(0xFFFFFFFF),
    onPrimarySoft: Color(0xD1FFFFFF),
    success: Color(0xFF3F9C6D),
    successSoft: Color(0xFFE1F2E7),
    warn: Color(0xFFDB8A3C),
    warnSoft: Color(0xFFFBEAD6),
    danger: Color(0xFFD9694F),
    dangerSoft: Color(0xFFF8E2DB),
  );

  static const dark = AppColors(
    bg: Color(0xFF14181A),
    surface: Color(0xFF1C2224),
    surfaceAlt: Color(0xFF242B2D),
    border: Color(0xFF323A3B),
    text: Color(0xFFF1EEE6),
    textSecondary: Color(0xFFACB1AA),
    textTertiary: Color(0xFF767D78),
    primary: Color(0xFF5FA893),
    primaryDark: Color(0xFF3E7E6C),
    primarySoft: Color(0xFF20302B),
    onPrimary: Color(0xFF0E1512),
    onPrimarySoft: Color(0xBF0E1512),
    success: Color(0xFF59B98A),
    successSoft: Color(0xFF1E2E26),
    warn: Color(0xFFE79A5C),
    warnSoft: Color(0xFF2E2620),
    danger: Color(0xFFE08770),
    dangerSoft: Color(0xFF2E2220),
  );
}
