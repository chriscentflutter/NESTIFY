import 'package:flutter/material.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final EdgeInsetsGeometry? padding;
  
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 56,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return SizedBox(
        width: width,
        height: height,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: backgroundColor ?? AppColors.primaryRed,
              width: 2,
            ),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: _buildButtonContent(),
        ),
      );
    }
    
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primaryRed,
          foregroundColor: textColor ?? AppColors.white,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
        ),
        child: _buildButtonContent(),
      ),
    );
  }
  
  Widget _buildButtonContent() {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
        ),
      );
    }
    
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTextStyles.button.copyWith(
              color: textColor ?? (isOutlined ? AppColors.primaryRed : AppColors.white),
            ),
          ),
        ],
      );
    }
    
    return Text(
      text,
      style: AppTextStyles.button.copyWith(
        color: textColor ?? (isOutlined ? AppColors.primaryRed : AppColors.white),
      ),
    );
  }
}

// Gradient Button
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final IconData? icon;
  final Gradient? gradient;
  final double? width;
  final double height;
  
  const GradientButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.gradient,
    this.width,
    this.height = 56,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(30),
          child: Ink(
            decoration: BoxDecoration(
              gradient: gradient ?? AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryRed.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: _buildButtonContent(),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildButtonContent() {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
        ),
      );
    }
    
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: AppColors.white),
          const SizedBox(width: 8),
          Text(text, style: AppTextStyles.button),
        ],
      );
    }
    
    return Text(text, style: AppTextStyles.button);
  }
}
