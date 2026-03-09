import 'package:flutter/material.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';
import 'package:nestify/core/widgets/wave_background.dart';
import 'package:nestify/presentation/screens/admin/add_property_screen.dart';

class ListingPlansScreen extends StatefulWidget {
  const ListingPlansScreen({Key? key}) : super(key: key);

  @override
  State<ListingPlansScreen> createState() => _ListingPlansScreenState();
}

class _ListingPlansScreenState extends State<ListingPlansScreen> {
  int _selectedPlanIndex = 1; // default: Pro

  final List<_PlanData> _plans = [
    _PlanData(
      name: 'Basic',
      price: 5000,
      period: 'month',
      emoji: '🌱',
      color: const Color(0xFF43A047),
      features: [
        'List up to 5 properties',
        'Standard listing visibility',
        'Limited analytics',
      ],
      limitations: [
        'No featured section',
        'No lead notifications',
        'No priority support',
      ],
    ),
    _PlanData(
      name: 'Pro',
      price: 10000,
      period: 'month',
      emoji: '🚀',
      color: AppColors.primaryRed,
      badge: 'POPULAR',
      features: [
        'List up to 15 properties',
        'Increased visibility (featured section)',
        'Advanced analytics',
        'Lead notifications',
      ],
      limitations: [
        'No homepage feature',
        'No priority support',
      ],
    ),
    _PlanData(
      name: 'Elite',
      price: 15000,
      period: 'month',
      emoji: '👑',
      color: const Color(0xFFF59E0B),
      features: [
        'Unlimited property listings',
        'Top visibility (homepage feature)',
        'Priority support',
        'Advanced analytics & lead insights',
      ],
      limitations: [],
    ),
    _PlanData(
      name: 'Premium Annual',
      price: 50000,
      period: 'year',
      emoji: '💎',
      color: const Color(0xFF7C3AED),
      badge: 'BEST VALUE',
      features: [
        'All Elite features included',
        'Dedicated account manager',
        'Custom branding',
        'Priority customer support',
        'Annual analytics report',
      ],
      limitations: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WaveBackground(
        showGradient: false,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  children: [
                    _buildSubheading(),
                    const SizedBox(height: 20),
                    ..._plans.asMap().entries.map((e) =>
                        _buildPlanCard(e.key, e.value)),
                    const SizedBox(height: 24),
                    _buildContinueButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.darkGray,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Choose a Plan', style: AppTextStyles.h3),
                Text(
                  'Select your listing subscription',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textGray),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.inventory_2_outlined,
                color: AppColors.white, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildSubheading() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primaryRed.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.primaryRed, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Choose a plan that fits your needs before listing your property. '
              'You can upgrade or change your plan anytime.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.lightGray,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(int index, _PlanData plan) {
    final isSelected = _selectedPlanIndex == index;
    final isAnnual = plan.period == 'year';

    return GestureDetector(
      onTap: () => setState(() => _selectedPlanIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? plan.color.withValues(alpha: 0.12)
              : AppColors.charcoal,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? plan.color
                : AppColors.mediumGray.withValues(alpha: 0.25),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: plan.color.withValues(alpha: 0.18),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Plan header row ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  // Emoji icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: plan.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(plan.emoji,
                          style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              plan.name,
                              style: AppTextStyles.h5.copyWith(
                                color: isSelected ? plan.color : AppColors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (plan.badge != null) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: plan.color,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  plan.badge!,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    '₦${_formatPrice(plan.price)}',
                                style: AppTextStyles.h4.copyWith(
                                  color: plan.color,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              TextSpan(
                                text: '/${plan.period}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Selection indicator
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? plan.color : AppColors.mediumGray,
                        width: 2,
                      ),
                      color: isSelected ? plan.color : Colors.transparent,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check,
                            color: AppColors.white, size: 14)
                        : null,
                  ),
                ],
              ),
            ),

            // ── Divider ────────────────────────────────────────────────────
            Divider(
              color: AppColors.mediumGray.withValues(alpha: 0.2),
              height: 1,
            ),

            // ── Features ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...plan.features.map((f) => _featureRow(f, plan.color, true)),
                  if (plan.limitations.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    ...plan.limitations
                        .map((f) => _featureRow(f, AppColors.textGray, false)),
                  ],
                  if (isAnnual) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: plan.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: plan.color.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.savings_outlined,
                              color: plan.color, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            'Billed annually — Save vs monthly Elite',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: plan.color,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureRow(String text, Color color, bool included) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            included ? Icons.check_circle : Icons.cancel_outlined,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                color: included ? AppColors.lightGray : AppColors.textGray,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    final plan = _plans[_selectedPlanIndex];
    return Column(
      children: [
        // Summary chip
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: plan.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border:
                Border.all(color: plan.color.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Text(plan.emoji,
                  style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected: ${plan.name} Plan',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: plan.color,
                      ),
                    ),
                    Text(
                      '₦${_formatPrice(plan.price)} / ${plan.period}',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textGray),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // CTA button
        SizedBox(
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [plan.color, plan.color.withValues(alpha: 0.7)],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: plan.color.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigate to the actual property listing form
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddPropertyScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add_home_outlined,
                  color: AppColors.white, size: 20),
              label: Text(
                'Continue — List Property',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Payment is processed securely. Cancel anytime.',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textGray,
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _formatPrice(int price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}K';
    }
    return price.toString();
  }
}

class _PlanData {
  final String name;
  final int price;
  final String period;
  final String emoji;
  final Color color;
  final String? badge;
  final List<String> features;
  final List<String> limitations;

  const _PlanData({
    required this.name,
    required this.price,
    required this.period,
    required this.emoji,
    required this.color,
    this.badge,
    required this.features,
    required this.limitations,
  });
}
