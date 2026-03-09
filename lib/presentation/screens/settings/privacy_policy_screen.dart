import 'package:flutter/material.dart';
import 'package:nestify/core/widgets/wave_background.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  int? _expandedSection;

  final List<Map<String, dynamic>> _sections = [
    {
      'title': '1. Information We Collect',
      'icon': Icons.info_outline,
      'content': '''We collect information you provide directly to us, including:
      
• Personal information (name, email, phone number)
• Profile information and preferences
• Property search history and favorites
• Payment information (processed securely)
• Device information and usage data

We use this information to provide and improve our services, personalize your experience, and communicate with you about properties and updates.'''
    },
    {
      'title': '2. How We Use Your Information',
      'icon': Icons.settings,
      'content': '''Your information is used to:

• Provide property listings and search functionality
• Connect you with verified agents
• Process transactions securely
• Send notifications about properties you're interested in
• Improve our services and user experience
• Comply with legal obligations

We never sell your personal information to third parties.'''
    },
    {
      'title': '3. Data Security',
      'icon': Icons.security,
      'content': '''We implement industry-standard security measures to protect your data:

• End-to-end encryption for sensitive data
• Secure payment processing via Flutterwave & Paystack
• Regular security audits and updates
• Secure data storage and backup systems
• Access controls and authentication

However, no method of transmission over the internet is 100% secure.'''
    },
    {
      'title': '4. Sharing of Information',
      'icon': Icons.share,
      'content': '''We may share your information with:

• Property agents (only when you express interest)
• Payment processors (for transactions)
• Service providers (for app functionality)
• Legal authorities (when required by law)

We ensure all third parties comply with data protection standards.'''
    },
    {
      'title': '5. Your Rights',
      'icon': Icons.verified_user,
      'content': '''You have the right to:

• Access your personal data
• Correct inaccurate information
• Delete your account and data
• Opt-out of marketing communications
• Export your data
• Withdraw consent at any time

Contact us at privacy@nestify.com to exercise these rights.'''
    },
    {
      'title': '6. Cookies and Tracking',
      'icon': Icons.cookie,
      'content': '''We use cookies and similar technologies to:

• Remember your preferences
• Analyze app usage and performance
• Provide personalized recommendations
• Improve security

You can manage cookie preferences in your device settings.'''
    },
    {
      'title': '7. Children\'s Privacy',
      'icon': Icons.child_care,
      'content': '''Our services are not intended for users under 18 years of age. We do not knowingly collect information from children. If you believe we have collected information from a child, please contact us immediately.'''
    },
    {
      'title': '8. Changes to This Policy',
      'icon': Icons.update,
      'content': '''We may update this privacy policy from time to time. We will notify you of any significant changes via email or app notification. Continued use of our services after changes constitutes acceptance of the updated policy.'''
    },
  ];

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
                    Expanded(
                      child: Text('Privacy Policy', style: AppTextStyles.h3),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryRed.withValues(alpha: 0.2),
                              AppColors.crimson.withValues(alpha: 0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primaryRed.withValues(alpha: 0.3),
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
                                  child: const Icon(
                                    Icons.privacy_tip,
                                    color: AppColors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Your Privacy Matters',
                                  style: AppTextStyles.h5,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Last updated: February 16, 2026',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textGray,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'This privacy policy explains how Nestify collects, uses, and protects your personal information.',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.lightGray,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Sections
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _sections.length,
                        itemBuilder: (context, index) {
                          final section = _sections[index];
                          final isExpanded = _expandedSection == index;
                          
                          return _buildPolicySection(
                            title: section['title'],
                            icon: section['icon'],
                            content: section['content'],
                            isExpanded: isExpanded,
                            onTap: () {
                              setState(() {
                                _expandedSection = isExpanded ? null : index;
                              });
                            },
                          );
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Contact Section
                      Container(
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
                                const Icon(
                                  Icons.contact_support,
                                  color: AppColors.primaryRed,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Questions?',
                                  style: AppTextStyles.h5,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'If you have any questions about this privacy policy, please contact us at:',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.lightGray,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'privacy@nestify.com',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primaryRed,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
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

  Widget _buildPolicySection({
    required String title,
    required IconData icon,
    required String content,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded
              ? AppColors.primaryRed.withValues(alpha: 0.5)
              : AppColors.mediumGray.withValues(alpha: 0.3),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isExpanded
                          ? AppColors.primaryRed.withValues(alpha: 0.2)
                          : AppColors.darkGray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      color: isExpanded ? AppColors.primaryRed : AppColors.textGray,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.primaryRed,
                  ),
                ],
              ),
              if (isExpanded) ...[
                const SizedBox(height: 16),
                Text(
                  content,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.lightGray,
                    height: 1.6,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
