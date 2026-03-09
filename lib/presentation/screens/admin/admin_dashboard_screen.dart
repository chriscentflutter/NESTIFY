import 'package:flutter/material.dart';
import 'package:nestify/core/widgets/wave_background.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';
import 'package:nestify/data/models/property_submission.dart';
import 'package:nestify/presentation/screens/admin/admin_management_screen.dart';
import 'package:nestify/presentation/screens/admin/add_property_screen.dart';
import 'package:nestify/presentation/screens/admin/agent_applications_screen.dart';
import 'package:nestify/presentation/screens/admin/all_users_screen.dart';
import 'package:nestify/presentation/screens/property/listing_plans_screen.dart';
import 'package:nestify/data/models/agent_application.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  PropertyStatus _selectedFilter = PropertyStatus.pending;
  
  // Mock data - replace with actual API call
  final List<PropertySubmission> _submissions = [
    PropertySubmission(
      id: '1',
      propertyId: 'prop_001',
      agentId: 'agent_001',
      agentName: 'Sarah Johnson',
      agentEmail: 'sarah.j@realestate.com',
      propertyTitle: 'Luxury 3BR Apartment in Lekki Phase 1',
      propertyType: 'apartment',
      price: 2500000,
      priceType: 'sale',
      status: PropertyStatus.pending,
      submittedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    PropertySubmission(
      id: '2',
      propertyId: 'prop_002',
      agentId: 'agent_002',
      agentName: 'Michael Obi',
      agentEmail: 'michael.o@properties.ng',
      propertyTitle: 'Modern Office Space in Victoria Island',
      propertyType: 'office',
      price: 500000,
      priceType: 'rent',
      status: PropertyStatus.pending,
      submittedAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    PropertySubmission(
      id: '3',
      propertyId: 'prop_003',
      agentId: 'agent_003',
      agentName: 'Amina Bello',
      agentEmail: 'amina.b@homes.ng',
      propertyTitle: 'Spacious 5BR Duplex in Ikoyi',
      propertyType: 'house',
      price: 5000000,
      priceType: 'sale',
      status: PropertyStatus.approved,
      submittedAt: DateTime.now().subtract(const Duration(days: 1)),
      reviewedAt: DateTime.now().subtract(const Duration(hours: 20)),
      reviewedBy: 'Admin',
    ),
  ];

  List<PropertySubmission> get _filteredSubmissions {
    return _submissions.where((s) => s.status == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WaveBackground(
        showGradient: false,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header can scroll if tight on space
                  SingleChildScrollView(child: _buildHeader()),
                  _buildStats(),
                  _buildFilterTabs(),
                  Expanded(
                    child: _buildSubmissionsList(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryRed,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.admin_panel_settings,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin Dashboard',
                      style: AppTextStyles.h3,
                    ),
                    Text(
                      'Property Approvals',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textGray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminManagementScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.people, size: 18),
                  label: const Text('Manage Admins'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.charcoal,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ListingPlansScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_home, size: 18),
                  label: const Text('Add Property'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Agent Applications button with pending badge
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllUsersScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.people_outline, size: 18),
                  label: const Text('All Users'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.charcoal,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                          color: AppColors.primaryRed.withValues(alpha: 0.4)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AgentApplicationsScreen(),
                      ),
                    );
                  },
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.badge, size: 18),
                      if (AgentApplicationStore.all.any(
                          (a) => a.status == AgentApplicationStatus.pending))
                        Positioned(
                          top: -4,
                          right: -4,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                  label: const Text('Agent Apps'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.charcoal,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                          color: Colors.orange.withValues(alpha: 0.4)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    final pendingCount = _submissions.where((s) => s.status == PropertyStatus.pending).length;
    final approvedCount = _submissions.where((s) => s.status == PropertyStatus.approved).length;
    final rejectedCount = _submissions.where((s) => s.status == PropertyStatus.rejected).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              label: 'Pending',
              value: pendingCount.toString(),
              color: Colors.orange,
              icon: Icons.pending_actions,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              label: 'Approved',
              value: approvedCount.toString(),
              color: Colors.green,
              icon: Icons.check_circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              label: 'Rejected',
              value: rejectedCount.toString(),
              color: Colors.red,
              icon: Icons.cancel,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.h4.copyWith(color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: PropertyStatus.values.map((status) {
          final isSelected = _selectedFilter == status;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilterChip(
              selected: isSelected,
              label: Text(status.displayName),
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = status;
                });
              },
              backgroundColor: AppColors.darkGray,
              selectedColor: AppColors.primaryRed,
              labelStyle: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? AppColors.white : AppColors.textGray,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSubmissionsList() {
    if (_filteredSubmissions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox,
              size: 64,
              color: AppColors.textGray,
            ),
            const SizedBox(height: 16),
            Text(
              'No ${_selectedFilter.displayName} Submissions',
              style: AppTextStyles.h5,
            ),
            const SizedBox(height: 8),
            Text(
              'All caught up!',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textGray,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _filteredSubmissions.length,
      itemBuilder: (context, index) {
        final submission = _filteredSubmissions[index];
        return _buildSubmissionCard(submission);
      },
    );
  }

  Widget _buildSubmissionCard(PropertySubmission submission) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.mediumGray.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        submission.propertyTitle,
                        style: AppTextStyles.h5,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 14,
                            color: AppColors.textGray,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            submission.agentName,
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(submission.status),
              ],
            ),
          ),

          const Divider(color: AppColors.mediumGray, height: 1),

          // Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDetailRow('Type', submission.propertyType.toUpperCase()),
                const SizedBox(height: 8),
                _buildDetailRow(
                  'Price',
                  '₦${submission.price.toStringAsFixed(0)} ${submission.priceType == "rent" ? "/month" : ""}',
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  'Submitted',
                  _formatDate(submission.submittedAt),
                ),
                if (submission.reviewedAt != null) ...[
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    'Reviewed',
                    _formatDate(submission.reviewedAt!),
                  ),
                ],
                if (submission.rejectionReason != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 16,
                          color: AppColors.error,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            submission.rejectionReason!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.error,
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

          // Actions
          if (submission.status == PropertyStatus.pending) ...[
            const Divider(color: AppColors.mediumGray, height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showRejectDialog(submission),
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Reject'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _approveSubmission(submission),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Approve'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(PropertyStatus status) {
    Color color;
    switch (status) {
      case PropertyStatus.pending:
        color = Colors.orange;
        break;
      case PropertyStatus.approved:
        color = Colors.green;
        break;
      case PropertyStatus.rejected:
        color = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        status.displayName,
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textGray,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _approveSubmission(PropertySubmission submission) {
    setState(() {
      final index = _submissions.indexWhere((s) => s.id == submission.id);
      _submissions[index] = submission.copyWith(
        status: PropertyStatus.approved,
        reviewedAt: DateTime.now(),
        reviewedBy: 'Admin',
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${submission.propertyTitle} approved'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showRejectDialog(PropertySubmission submission) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.charcoal,
        title: Text('Reject Property', style: AppTextStyles.h5),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please provide a reason for rejection:',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.lightGray,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter rejection reason...',
                filled: true,
                fillColor: AppColors.darkGray,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please provide a rejection reason'),
                    backgroundColor: AppColors.error,
                  ),
                );
                return;
              }

              setState(() {
                final index = _submissions.indexWhere((s) => s.id == submission.id);
                _submissions[index] = submission.copyWith(
                  status: PropertyStatus.rejected,
                  rejectionReason: reasonController.text.trim(),
                  reviewedAt: DateTime.now(),
                  reviewedBy: 'Admin',
                );
              });

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${submission.propertyTitle} rejected'),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }
}
