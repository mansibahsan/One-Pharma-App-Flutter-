import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Brand Colors (from Mediphrma UI Kit)
  static const Color primary = Color(0xFFFF4858);
  static const Color primaryDark = Color(0xFFDE3343);
  static const Color primaryLight = Color(0xFFFFEFF1);
  static const Color primaryTonal = Color(0xFFFFF0F2);
  static const Color primaryAccent = Color(0xFFFF6B79);

  // Backgrounds & Surfaces
  static const Color background = Color(0xFFFFFFFF);
  static const Color scaffoldBackground = Color(0xFFFBFBFC);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color inputBg = Color(0xFFF6F7FB);
  static const Color pillBg = Color(0xFFFFF2F4);

  // Text Colors
  static const Color textPrimary = Color(0xFF1E2432);
  static const Color textSecondary = Color(0xFF667085);
  static const Color textMuted = Color(0xFF98A2B3);
  static const Color textLight = Color(0xFFCBD5E1);

  // Status & Utility Colors
  static const Color success = Color(0xFF12B76A);
  static const Color successLight = Color(0xFFECFDF3);
  static const Color warning = Color(0xFFF79009);
  static const Color warningLight = Color(0xFFFEF0C7);
  static const Color error = Color(0xFFF04438);
  static const Color info = Color(0xFF2E90FA);
  static const Color star = Color(0xFFFFAB00);

  // Borders & Dividers
  static const Color border = Color(0xFFEAECF0);
  static const Color borderSubtle = Color(0xFFF2F4F7);
  static const Color divider = Color(0xFFF0F2F5);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF5E6D), Color(0xFFFF4858)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bannerGradient1 = LinearGradient(
    colors: [Color(0xFFFFEDEE), Color(0xFFFFDFE3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bannerGradient2 = LinearGradient(
    colors: [Color(0xFFE8F4FD), Color(0xFFD4EAFC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
