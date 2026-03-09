import 'package:flutter/material.dart';
import 'package:nestify/core/widgets/wave_background.dart';
import 'package:nestify/core/widgets/custom_button.dart';
import 'package:nestify/core/widgets/custom_text_field.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                  const SizedBox(height: 40),
                  
                  // Logo
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryRed.withValues(alpha: 0.3),
                            blurRadius: 15,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.home_work,
                        size: 60,
                        color: AppColors.primaryRed,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Welcome Text
                  Text(
                    'Welcome Back!',
                    style: AppTextStyles.h2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.lightGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  
                  // Email Field
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email or Phone',
                    hint: 'Enter your email or phone number',
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email or phone';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // Password Field
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Enter your password',
                    prefixIcon: Icons.lock,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/forgot-password');
                      },
                      child: Text(
                        'Forgot Password?',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primaryRed,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Login Button
                  GradientButton(
                    text: 'Sign In',
                    onPressed: _handleLogin,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 24),
                  
                  // Divider
                  Row(
                    children: [
                      const Expanded(child: Divider(color: AppColors.mediumGray)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                      const Expanded(child: Divider(color: AppColors.mediumGray)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Social Login Buttons
                  CustomButton(
                    text: 'Continue with Google',
                    onPressed: _handleGoogleLogin,
                    icon: Icons.g_mobiledata,
                    backgroundColor: AppColors.white,
                    textColor: AppColors.richBlack,
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Continue with Apple',
                    onPressed: _handleAppleLogin,
                    icon: Icons.apple,
                    backgroundColor: AppColors.charcoal,
                  ),
                  const SizedBox(height: 32),
                  
                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTextStyles.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/signup');
                        },
                        child: Text(
                          'Sign Up',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primaryRed,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      // TODO: Implement login logic
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pushReplacementNamed('/home');
        }
      });
    }
  }

  void _handleGoogleLogin() {
    // TODO: Implement Google login
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google login coming soon')),
    );
  }

  void _handleAppleLogin() {
    // TODO: Implement Apple login
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Apple login coming soon')),
    );
  }
}
