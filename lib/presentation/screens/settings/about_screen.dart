import 'package:flutter/material.dart';
import 'package:nestify/core/widgets/wave_background.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WaveBackground(
        showGradient: false,
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: AppColors.white),
                    ),
                    const SizedBox(width: 12),
                    Text('About', style: AppTextStyles.h3),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      
                      // App Logo
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryRed.withValues(alpha: 0.4),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.home_work,
                          size: 60,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // App Name
                      Text(
                        'NESTIFY',
                        style: AppTextStyles.h2.copyWith(
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Version
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryRed.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primaryRed.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          'Version 1.0.0',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primaryRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Description
                      _buildInfoCard(
                        icon: Icons.info_outline,
                        title: 'About Nestify',
                        content: 'Your trusted partner in finding the perfect property. Browse, save, and connect with verified agents for residential and commercial properties.',
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Developer Info
                      _buildInfoCard(
                        icon: Icons.code,
                        title: 'Developer',
                        content: 'Developed with ❤️ by the Nestify Team\n© 2026 Nestify. All rights reserved.',
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Contact
                      _buildInfoCard(
                        icon: Icons.email_outlined,
                        title: 'Contact Us',
                        content: 'support@nestify.com\n+234 800 123 4567',
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Links
                      _buildLinkButton(
                        icon: Icons.description_outlined,
                        label: 'Terms & Conditions',
                        onTap: () {
                          // TODO: Navigate to terms
                        },
                      ),
                      
                      const SizedBox(height: 12),
                      
                      _buildLinkButton(
                        icon: Icons.privacy_tip_outlined,
                        label: 'Privacy Policy',
                        onTap: () {
                          Navigator.pushNamed(context, '/privacy-policy');
                        },
                      ),
                      
                      const SizedBox(height: 12),
                      
                      _buildLinkButton(
                        icon: Icons.open_in_new,
                        label: 'Visit Our Website',
                        onTap: () async {
                          // TODO: Add actual website URL
                          final uri = Uri.parse('https://nestify.com');
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          }
                        },
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Social Media
                      Text(
                        'Follow Us',
                        style: AppTextStyles.h5,
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialButton(Icons.facebook, () {}),
                          const SizedBox(width: 16),
                          _buildSocialButton(Icons.camera_alt, () {}), // Instagram
                          const SizedBox(width: 16),
                          _buildSocialButton(Icons.send, () {}), // Twitter/X
                          const SizedBox(width: 16),
                          _buildSocialButton(Icons.link, () {}), // LinkedIn
                        ],
                      ),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.mediumGray.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppTextStyles.h5,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.lightGray,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.darkGray,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryRed.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryRed, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textGray,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.darkGray,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryRed.withValues(alpha: 0.3),
          ),
        ),
        child: Icon(icon, color: AppColors.primaryRed, size: 24),
      ),
    );
  }
}
