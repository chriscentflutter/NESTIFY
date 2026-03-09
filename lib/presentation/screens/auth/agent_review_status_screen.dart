import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';
import 'package:nestify/core/widgets/wave_background.dart';

class AgentReviewStatusScreen extends StatelessWidget {
  const AgentReviewStatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: WaveBackground(
        child: SafeArea(
          child: user == null
              ? _buildNotLoggedIn(context)
              : StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('agent_applications')
                      .doc(user.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryRed,
                        ),
                      );
                    }

                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return _buildNoApplication(context);
                    }

                    final data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    final status = data['status'] as String? ?? 'pending';

                    return _buildStatusView(context, data, status);
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildStatusView(
      BuildContext context, Map<String, dynamic> data, String status) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          _buildStatusIcon(status),
          const SizedBox(height: 24),
          Text(
            _statusTitle(status),
            style: AppTextStyles.h2.copyWith(color: AppColors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            _statusMessage(status),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.lightGray,
              height: 1.55,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),

          // Application Details Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.charcoal,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: _statusColor(status).withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Application Details',
                        style: AppTextStyles.h5.copyWith(
                            color: AppColors.white)),
                    _buildStatusBadge(status),
                  ],
                ),
                const Divider(color: AppColors.mediumGray, height: 24),

                _detailRow(Icons.person_outline, 'Full Name',
                    data['fullName'] ?? '—'),
                const SizedBox(height: 12),
                _detailRow(Icons.email_outlined, 'Email',
                    data['email'] ?? '—'),
                const SizedBox(height: 12),
                _detailRow(Icons.phone_outlined, 'Phone',
                    data['phone'] ?? '—'),
                const SizedBox(height: 12),
                _detailRow(Icons.location_on_outlined, 'Address',
                    data['address'] ?? '—'),
                const SizedBox(height: 12),
                _detailRow(
                    Icons.badge_outlined, 'NIN', data['nin'] ?? '—'),
                if (data['passportUrl'] != null) ...[
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.mediumGray, height: 1),
                  const SizedBox(height: 16),
                  Text('Passport / ID Photo',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textGray)),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      data['passportUrl'],
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (_, child, progress) => progress == null
                          ? child
                          : Container(
                              height: 160,
                              color: AppColors.darkGray,
                              child: const Center(
                                child: CircularProgressIndicator(
                                    color: AppColors.primaryRed),
                              ),
                            ),
                    ),
                  ),
                ],

                // Rejection Reason (if rejected)
                if (status == 'rejected' &&
                    data['rejectionReason'] != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.35)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline,
                            color: AppColors.error, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Reason: ${data['rejectionReason']}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.error,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Action Buttons
          if (status == 'approved') ...[
            SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryRed.withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (r) => false),
                  icon: const Icon(Icons.home, color: AppColors.white),
                  label: Text(
                    'Go to App',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          if (status == 'rejected') ...[
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushReplacementNamed(
                    context, '/agent-signup'),
                icon: const Icon(Icons.refresh, color: AppColors.primaryRed),
                label: Text(
                  'Re-apply with Updated Details',
                  style: AppTextStyles.bodyLarge
                      .copyWith(color: AppColors.primaryRed),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primaryRed),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Logout
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (r) => false);
              },
              icon:
                  const Icon(Icons.logout, color: AppColors.textGray, size: 18),
              label: Text('Sign Out',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textGray)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(String status) {
    final color = _statusColor(status);
    final icon = status == 'approved'
        ? Icons.verified_rounded
        : status == 'rejected'
            ? Icons.cancel_rounded
            : Icons.hourglass_top_rounded;

    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: status == 'pending'
            ? AppColors.primaryGradient
            : null,
        color: status != 'pending' ? color.withValues(alpha: 0.15) : null,
        border: status != 'pending'
            ? Border.all(color: color, width: 2.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.35),
            blurRadius: 28,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Icon(icon, color: status == 'pending' ? AppColors.white : color,
          size: 52),
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: AppColors.primaryRed),
        const SizedBox(width: 10),
        Text('$label: ',
            style:
                AppTextStyles.bodySmall.copyWith(color: AppColors.textGray)),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotLoggedIn(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, color: AppColors.textGray, size: 64),
          const SizedBox(height: 16),
          Text('Session Expired', style: AppTextStyles.h4),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/login'),
            child: const Text('Log In Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoApplication(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox, color: AppColors.textGray, size: 64),
            const SizedBox(height: 16),
            Text('No Application Found', style: AppTextStyles.h4),
            const SizedBox(height: 8),
            Text(
              'We could not find a submitted application for your account.',
              style:
                  AppTextStyles.bodyMedium.copyWith(color: AppColors.textGray),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/agent-signup'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
              ),
              child: const Text('Submit Application'),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _statusTitle(String status) {
    switch (status) {
      case 'approved':
        return 'Application Approved! 🎉';
      case 'rejected':
        return 'Application Rejected';
      default:
        return 'Application Under Review';
    }
  }

  String _statusMessage(String status) {
    switch (status) {
      case 'approved':
        return 'Congratulations! Your agent account has been verified. You can now list properties on Nestify.';
      case 'rejected':
        return 'Unfortunately your application was not approved. Please review the reason below and re-apply with updated details.';
      default:
        return 'Our team is reviewing your application. This usually takes 1–2 business days. You will be notified once a decision has been made.';
    }
  }
}
