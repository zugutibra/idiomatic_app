import 'package:flutter/material.dart';

import 'package:idiomatic_app/core/theme/app_theme.dart';

/// Primary filled pill button — matches the design's 16px-radius, 16px-pad,
/// weight-800 primary buttons (Log In, Create Account, Start Review, ...).
class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: colors.onPrimary),
              )
            : Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
      ),
    );
  }
}

/// Outlined secondary button — matches "Take a Quiz" / "Try Again".
class AppOutlineButton extends StatelessWidget {
  const AppOutlineButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.text,
          side: BorderSide(color: colors.border, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
