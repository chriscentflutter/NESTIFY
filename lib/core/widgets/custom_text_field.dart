import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.inputFormatters,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.label,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          maxLines: widget.maxLines,
          inputFormatters: widget.inputFormatters,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: AppColors.textGray)
                : null,
            suffixIcon: _buildSuffixIcon(),
            filled: true,
            fillColor: widget.enabled ? AppColors.darkGray : AppColors.mediumGray,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryRed, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget? _buildSuffixIcon() {
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppColors.textGray,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }
    
    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(widget.suffixIcon, color: AppColors.textGray),
        onPressed: widget.onSuffixIconTap,
      );
    }
    
    return null;
  }
}

// Search Text Field
class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final void Function(String)? onChanged;
  final VoidCallback? onFilterTap;
  
  const SearchTextField({
    Key? key,
    required this.controller,
    this.hint = 'Search properties...',
    this.onChanged,
    this.onFilterTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGray),
          prefixIcon: const Icon(Icons.search, color: AppColors.textGray),
          suffixIcon: onFilterTap != null
              ? IconButton(
                  icon: const Icon(Icons.tune, color: AppColors.primaryRed),
                  onPressed: onFilterTap,
                )
              : null,
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryRed, width: 2),
          ),
        ),
      ),
    );
  }
}
