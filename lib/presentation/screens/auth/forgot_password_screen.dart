import 'package:flutter/material.dart';
import 'package:nestify/core/widgets/wave_background.dart';
import 'package:nestify/core/widgets/custom_button.dart';
import 'package:nestify/core/widgets/custom_text_field.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WaveBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  
                  // Back Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Icon
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryRed.withValues(alpha: 0.3),
                            blurRadius: 15,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.lock_reset,
                        size: 50,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Title
                  Text(
                    'Forgot Password?',
                    style: AppTextStyles.h2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _emailSent
                        ? 'Check your email for password reset instructions'
                        : 'Enter your email and we\'ll send you instructions to reset your password',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.lightGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  
                  if (!_emailSent) ...[
                    // Email Field
                    CustomTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'Enter your email',
                      prefixIcon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    
                    // Send Button
                    GradientButton(
                      text: 'Send Reset Link',
                      onPressed: _handleSendResetLink,
                      isLoading: _isLoading,
                    ),
                  ] else ...[
                    // Success Icon
                    const Icon(
                      Icons.check_circle,
                      size: 80,
                      color: AppColors.success,
                    ),
                    const SizedBox(height: 32),
                    
                    // Resend Button
                    CustomButton(
                      text: 'Resend Email',
                      onPressed: _handleSendResetLink,
                      isOutlined: true,
                    ),
                    const SizedBox(height: 16),
                    
                    // Back to Login
                    GradientButton(
                      text: 'Back to Login',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleSendResetLink() {
    if (!_emailSent && !_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    // TODO: Implement password reset logic
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _emailSent = true;
        });
      }
    });
  }
}
