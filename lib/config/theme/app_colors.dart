import 'package:flutter/material.dart';

class AppColors {
  // ============ DARK MODE COLORS ============
  
  // Primary Colors - Red Shades (Dark Mode)
  static const Color primaryRed = Color(0xFFC41E3A); // Deep Red
  static const Color crimson = Color(0xFFDC143C); // Crimson
  static const Color darkRed = Color(0xFF8B0000); // Dark Red
  static const Color lightRed = Color(0xFFFF6B6B); // Light Red for accents
  
  // Secondary Colors - Black Shades (Dark Mode)
  static const Color richBlack = Color(0xFF0A0A0A); // Rich Black
  static const Color charcoal = Color(0xFF1A1A1A); // Charcoal
  static const Color darkGray = Color(0xFF2A2A2A); // Dark Gray
  static const Color mediumGray = Color(0xFF3A3A3A); // Medium Gray
  
  // Neutral Colors (Shared)
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF5F5F5);
  static const Color lightGray = Color(0xFFE0E0E0);
  static const Color textGray = Color(0xFF757575);
  
  // ============ LIGHT MODE COLORS ============
  
  // Background Colors (Light Mode)
  static const Color lightBackground = Color(0xFFFAFAFA); // Light Background
  static const Color lightSurface = Color(0xFFFFFFFF); // White Surface
  static const Color lightCard = Color(0xFFFFFFFF); // White Card
  static const Color lightDivider = Color(0xFFE0E0E0); // Light Divider
  
  // Text Colors (Light Mode)
  static const Color lightTextPrimary = Color(0xFF212121); // Dark Text
  static const Color lightTextSecondary = Color(0xFF757575); // Gray Text
  static const Color lightTextTertiary = Color(0xFF9E9E9E); // Light Gray Text
  
  // Surface Colors (Light Mode)
  static const Color lightElevated = Color(0xFFFFFFFF); // Elevated Surface
  static const Color lightBorder = Color(0xFFE0E0E0); // Border Color
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryRed, crimson],
  );
  
  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [richBlack, charcoal],
  );
  
  static const LinearGradient lightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFAFAFA), Color(0xFFFFFFFF)],
  );
  
  static const LinearGradient redBlackGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryRed, richBlack],
  );
  
  static const LinearGradient waveGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFC41E3A), // Primary Red
      Color(0xFF8B0000), // Dark Red
      Color(0xFF1A1A1A), // Charcoal
      Color(0xFF0A0A0A), // Rich Black
    ],
    stops: [0.0, 0.3, 0.7, 1.0],
  );
  
  // Status Colors (Shared)
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF29B6F6);
  
  // Overlay Colors
  static Color blackOverlay = Colors.black.withValues(alpha: 0.5);
  static Color redOverlay = primaryRed.withValues(alpha: 0.1);
  static Color whiteOverlay = Colors.white.withValues(alpha: 0.5);
  
  // ============ CONTEXT-AWARE COLORS ============
  
  // Get background color based on theme
  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? richBlack
        : lightBackground;
  }
  
  // Get surface color based on theme
  static Color getSurfaceColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? charcoal
        : lightSurface;
  }
  
  // Get card color based on theme
  static Color getCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? charcoal
        : lightCard;
  }
  
  // Get text color based on theme
  static Color getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? white
        : lightTextPrimary;
  }
  
  // Get secondary text color based on theme
  static Color getSecondaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? textGray
        : lightTextSecondary;
  }
  
  // Get border color based on theme
  static Color getBorderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? mediumGray
        : lightBorder;
  }
  
  // Get divider color based on theme
  static Color getDividerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? mediumGray
        : lightDivider;
  }
}
