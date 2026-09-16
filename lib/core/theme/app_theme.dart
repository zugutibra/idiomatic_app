import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:idiomatic_app/core/theme/app_colors.dart';

/// Exposes the design's raw color tokens through the widget tree so widgets
/// can read `AppTheme.colorsOf(context)` instead of hard-coding hex values.
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension(this.colors);

  final AppColors colors;

  @override
  AppColorsExtension copyWith({AppColors? colors}) =>
      AppColorsExtension(colors ?? this.colors);

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return t < 0.5 ? this : other;
  }
}

class AppTheme {
  const AppTheme._();

  static AppColors colorsOf(BuildContext context) =>
      Theme.of(context).extension<AppColorsExtension>()!.colors;

  static TextStyle serifItalic(BuildContext context, {required double size, Color? color}) {
    return GoogleFonts.instrumentSerif(
      fontStyle: FontStyle.italic,
      fontSize: size,
      color: color ?? colorsOf(context).text,
      height: 1.0,
    );
  }

  static ThemeData build(AppColors colors) {
    final base = GoogleFonts.manropeTextTheme();
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: colors.bg,
      fontFamily: GoogleFonts.manrope().fontFamily,
      textTheme: base.apply(bodyColor: colors.text, displayColor: colors.text),
      colorScheme: ColorScheme(
        brightness: colors.bg.computeLuminance() > 0.5 ? Brightness.light : Brightness.dark,
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        secondary: colors.primary,
        onSecondary: colors.onPrimary,
        error: colors.danger,
        onError: colors.onPrimary,
        surface: colors.surface,
        onSurface: colors.text,
      ),
      extensions: [AppColorsExtension(colors)],
    );
  }

  static ThemeData light = build(AppColors.light);
  static ThemeData dark = build(AppColors.dark);
}
