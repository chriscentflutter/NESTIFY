import 'package:flutter/material.dart';
import 'package:nestify/core/widgets/wave_background.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({Key? key}) : super(key: key);

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  int? _expandedIndex;

  final List<Map<String, String>> _faqs = [
    {
      'question': 'How do I search for properties?',
      'answer': 'Use the search tab to browse properties. You can filter by location, price range, property type, and more. Save your favorite properties for quick access later.',
    },
    {
      'question': 'How do I contact an agent?',
      'answer': 'On any property detail page, you\'ll find the agent\'s contact information. You can call, email, or send a message directly through the app.',
    },
    {
      'question': 'Can I save properties for later?',
      'answer': 'Yes! Tap the heart icon on any property to add it to your favorites. Access all saved properties from the Favorites tab.',
    },
    {
      'question': 'How do I schedule a property viewing?',
      'answer': 'Contact the agent through the property details page to schedule a viewing. Some properties may offer instant booking options.',
    },
    {
      'question': 'Is my payment information secure?',
      'answer': 'Absolutely! We use industry-standard encryption and secure payment gateways (Flutterwave & Paystack) to protect your financial information.',
    },
    {
      'question': 'How do I update my profile?',
      'answer': 'Go to the Profile tab and tap "Edit Profile" to update your information, including name, email, phone number, and profile picture.',
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
                    Text('Help & Support', style: AppTextStyles.h3),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Contact Options
                      Row(
                        children: [
                          Expanded(
                            child: _buildContactCard(
                              icon: Icons.chat_bubble_outline,
                              label: 'Live Chat',
                              onTap: () async {
                                final uri = Uri.parse(
                                  'https://wa.me/2349038193950',
                                );
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildContactCard(
                              icon: Icons.email_outlined,
                              label: 'Email Us',
                              onTap: () async {
                                final uri = Uri(
                                  scheme: 'mailto',
                                  path: 'nestifycrib@gmail.com',
                                  query: 'subject=Support Request',
                                );
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      Row(
                        children: [
                          Expanded(
                            child: _buildContactCard(
                              icon: Icons.phone_outlined,
                              label: 'Call Us',
                              onTap: () async {
                                final uri = Uri(scheme: 'tel', path: '09038193950');
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildContactCard(
                              icon: Icons.help_outline,
                              label: 'FAQs',
                              onTap: () {
                                // Scroll to FAQs section
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // FAQs Section
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.question_answer,
                              color: AppColors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Frequently Asked Questions',
                            style: AppTextStyles.h5,
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // FAQ List
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _faqs.length,
                        itemBuilder: (context, index) {
                          final faq = _faqs[index];
                          final isExpanded = _expandedIndex == index;
                          
                          return _buildFAQItem(
                            question: faq['question']!,
                            answer: faq['answer']!,
                            isExpanded: isExpanded,
                            onTap: () {
                              setState(() {
                                _expandedIndex = isExpanded ? null : index;
                              });
                            },
                          );
                        },
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Still Need Help
                      Container(
                        padding: const EdgeInsets.all(24),
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
                          children: [
                            const Icon(
                              Icons.support_agent,
                              size: 48,
                              color: AppColors.primaryRed,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Still Need Help?',
                              style: AppTextStyles.h5,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Our support team is available 24/7 to assist you',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.lightGray,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () async {
                                final uri = Uri(
                                  scheme: 'mailto',
                                  path: 'nestifycrib@gmail.com',
                                );
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                }
                              },
                              icon: const Icon(Icons.email),
                              label: const Text('Contact Support'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryRed,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
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

  Widget _buildContactCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.charcoal,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.mediumGray.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.white, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
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
                  Expanded(
                    child: Text(
                      question,
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
                const SizedBox(height: 12),
                Text(
                  answer,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.lightGray,
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Live chat coming soon!'),
        backgroundColor: AppColors.primaryRed,
      ),
    );
  }
}
