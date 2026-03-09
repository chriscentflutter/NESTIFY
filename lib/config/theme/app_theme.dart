import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryRed,
      scaffoldBackgroundColor: AppColors.richBlack,
      
      // Color Scheme
      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        primary: AppColors.primaryRed,
        secondary: AppColors.crimson,
        surface: AppColors.charcoal,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.white,
        onError: AppColors.white,
      ),
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.white),
        titleTextStyle: AppTextStyles.h4,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.charcoal,
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: AppColors.white,
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryRed,
          side: const BorderSide(color: AppColors.primaryRed, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryRed,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: AppTextStyles.button,
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkGray,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.primaryRed, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: AppTextStyles.label,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGray),
        errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.white,
        size: 24,
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.charcoal,
        selectedItemColor: AppColors.primaryRed,
        unselectedItemColor: AppColors.textGray,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.white,
        elevation: 6,
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkGray,
        selectedColor: AppColors.primaryRed,
        labelStyle: AppTextStyles.bodySmall,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.mediumGray,
        thickness: 1,
        space: 1,
      ),
    );
  }

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryRed,
      scaffoldBackgroundColor: AppColors.lightBackground,
      
      // Color Scheme
      colorScheme: const ColorScheme.light(
        brightness: Brightness.light,
        primary: AppColors.primaryRed,
        secondary: AppColors.crimson,
        surface: AppColors.lightSurface,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.lightTextPrimary,
        onError: AppColors.white,
      ),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
        titleTextStyle: AppTextStyles.h4.copyWith(color: AppColors.lightTextPrimary),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: AppColors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryRed,
          side: const BorderSide(color: AppColors.primaryRed, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryRed,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: AppTextStyles.button,
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.offWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.primaryRed, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: AppTextStyles.label.copyWith(color: AppColors.lightTextSecondary),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.lightTextSecondary),
        errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.lightTextPrimary,
        size: 24,
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedItemColor: AppColors.primaryRed,
        unselectedItemColor: AppColors.lightTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.white,
        elevation: 4,
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.offWhite,
        selectedColor: AppColors.primaryRed,
        labelStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.lightTextPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.lightDivider,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
