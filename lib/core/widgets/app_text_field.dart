import 'package:flutter/material.dart';

import 'package:idiomatic_app/core/theme/app_theme.dart';

/// Labeled text field matching the design: uppercase 11.5px label, 14px
/// radius, 1px border in the theme's border color.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.placeholder,
  });

  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: colors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: TextStyle(fontSize: 15, color: colors.text),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: colors.textTertiary),
            filled: true,
            fillColor: colors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: colors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: colors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: colors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
