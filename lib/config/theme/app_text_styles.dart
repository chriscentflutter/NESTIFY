import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Heading Styles
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    letterSpacing: -0.5,
  );
  
  static const TextStyle h2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    letterSpacing: -0.5,
  );
  
  static const TextStyle h3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );
  
  static const TextStyle h4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );
  
  static const TextStyle h5 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );
  
  // Body Styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.white,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.white,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textGray,
    height: 1.5,
  );
  
  // Button Styles
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    letterSpacing: 0.5,
  );
  
  static const TextStyle buttonSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    letterSpacing: 0.5,
  );
  
  // Caption & Label Styles
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textGray,
  );
  
  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );
  
  // Price Styles
  static const TextStyle priceMain = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryRed,
  );
  
  static const TextStyle priceSecondary = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.crimson,
  );
}
