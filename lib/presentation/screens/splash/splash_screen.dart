import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nestify/core/widgets/wave_background.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Set status bar to transparent
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    
    // Initialize animations
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );
    
    // Start animation
    _controller.forward();
    
    // Navigate to onboarding after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedWaveBackground(
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryRed.withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.home_work,
                          size: 80,
                          color: AppColors.primaryRed,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // App Name
                      ShaderMask(
                        shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
                        child: const Text(
                          'NESTIFY',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Tagline
                      Text(
                        'Find Your Perfect Home',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.lightGray,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 60),
                      
                      // Loading Indicator
                      const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
