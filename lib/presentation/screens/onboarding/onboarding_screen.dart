import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:nestify/core/widgets/wave_background.dart';
import 'package:nestify/core/widgets/custom_button.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: Icons.home_work,
      title: 'Find Your Dream Home',
      description:
          'Browse through thousands of apartments, houses, offices, and land listings across Nigeria.',
    ),
    OnboardingPage(
      icon: Icons.payment,
      title: 'Secure Payments',
      description:
          'Pay online or on-site with our secure payment system. Multiple payment options available.',
    ),
    OnboardingPage(
      icon: Icons.manage_accounts,
      title: 'Estate Management',
      description:
          'Manage your rentals, schedule inspections, and handle maintenance requests all in one place.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WaveBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Skip Button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _goToLogin,
                  child: Text(
                    'Skip',
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.lightGray,
                    ),
                  ),
                ),
              ),
              
              // Page View
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
              ),
              
              // Page Indicator
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: _pages.length,
                  effect: WormEffect(
                    dotColor: AppColors.mediumGray,
                    activeDotColor: AppColors.primaryRed,
                    dotHeight: 12,
                    dotWidth: 12,
                    spacing: 16,
                  ),
                ),
              ),
              
              // Navigation Buttons
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    if (_currentPage > 0)
                      Expanded(
                        child: CustomButton(
                          text: 'Back',
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          isOutlined: true,
                        ),
                      ),
                    if (_currentPage > 0) const SizedBox(width: 16),
                    Expanded(
                      child: GradientButton(
                        text: _currentPage == _pages.length - 1
                            ? 'Get Started'
                            : 'Next',
                        onPressed: () {
                          if (_currentPage == _pages.length - 1) {
                            _goToLogin();
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryRed.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              page.icon,
              size: 80,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 48),
          
          // Title
          Text(
            page.title,
            style: AppTextStyles.h2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          // Description
          Text(
            page.description,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.lightGray,
            ),
            textAlign: TextAlign.center,
          ),
        ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacementNamed('/login');
  }
}

class OnboardingPage {
  final IconData icon;
  final String title;
  final String description;

  OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
  });
}
