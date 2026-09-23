import 'package:flutter/material.dart';

/// SoftKormo brand palette — sourced from the official logo.
abstract class AppColors {
  // ---------------------------------------------------------------- primary
  static const Color deepBlue = Color(0xFF0B3C88);
  static const Color tealGreen = Color(0xFF00B894);
  static const Color purple = Color(0xFF7B2CBF);
  static const Color magenta = Color(0xFFE91E63);
  static const Color orange = Color(0xFFFF7A00);

  // ------------------------------------------------------------- deep shades
  static const Color deepBlueDark = Color(0xFF072A61);
  static const Color deepBlueLight = Color(0xFF1A55B8);

  // ---------------------------------------------------------------- surfaces
  static const Color background = Color(0xFFF8FAFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceGlass = Color(0xF0FFFFFF);

  /// Fill for the sticky glass navbar: translucent enough for the backdrop
  /// blur to show the page sliding beneath it (surfaceGlass is 94% opaque,
  /// which would hide the blur almost completely).
  static const Color glassHeader = Color(0xC4FFFFFF);
  static const Color backgroundDark = Color(0xFF060D1F);
  static const Color surfaceDark = Color(0xFF0D1730);

  // ------------------------------------------------------------------- text
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textOnDark = Color(0xFFF1F5F9);
  static const Color textOnDarkMuted = Color(0xFFB6C2DA);

  // ---------------------------------------------------------------- borders
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderDark = Color(0xFF1E2B47);

  // ----------------------------------------------------------------- status
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFDC2626);

  // -------------------------------------------------------------- gradients
  static const LinearGradient brandGradient = LinearGradient(
    colors: [deepBlue, purple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [tealGreen, deepBlueLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient vibrantGradient = LinearGradient(
    colors: [magenta, orange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0B3C88), Color(0xFF134BB8), Color(0xFF7B2CBF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const RadialGradient heroGlow = RadialGradient(
    center: Alignment(0.6, -0.4),
    radius: 1.2,
    colors: [Color(0x6600B894), Color(0x000B3C88)],
  );

  /// Every brand hue in order — used for decorative multi-color accents.
  static const List<Color> brandPalette = [
    deepBlue,
    tealGreen,
    purple,
    magenta,
    orange,
  ];
}
