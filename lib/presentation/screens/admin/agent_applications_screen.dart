import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nestify/core/widgets/wave_background.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';

class AgentApplicationsScreen extends StatefulWidget {
  const AgentApplicationsScreen({Key? key}) : super(key: key);

  @override
  State<AgentApplicationsScreen> createState() =>
      _AgentApplicationsScreenState();
}

class _AgentApplicationsScreenState extends State<AgentApplicationsScreen> {
  late final FirebaseFirestore _firestore;
  String _selectedFilter = 'pending';

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
  }

  // ─── Firestore helpers ────────────────────────────────────────────────────

  Stream<QuerySnapshot> get _applicationsStream {
    if (_selectedFilter == 'all') {
      return _firestore
          .collection('agent_applications')
          .orderBy('submittedAt', descending: true)
          .snapshots();
    }
    return _firestore
        .collection('agent_applications')
        .where('status', isEqualTo: _selectedFilter)
        .orderBy('submittedAt', descending: true)
        .snapshots();
  }

  Future<void> _approve(String docId, String name) async {
    await _firestore.collection('agent_applications').doc(docId).update({
      'status': 'approved',
      'reviewedAt': FieldValue.serverTimestamp(),
      'reviewedBy': 'Admin',
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$name\'s application approved ✓'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Future<void> _reject(String docId, String name, String reason) async {
    await _firestore.collection('agent_applications').doc(docId).update({
      'status': 'rejected',
      'rejectionReason': reason,
      'reviewedAt': FieldValue.serverTimestamp(),
      'reviewedBy': 'Admin',
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$name\'s application rejected'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _showRejectDialog(String docId, String name) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.charcoal,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Reject Application', style: AppTextStyles.h5),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Provide a reason for rejecting $name\'s application:',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.lightGray),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              maxLines: 3,
              style: AppTextStyles.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Enter rejection reason...',
                filled: true,
                fillColor: AppColors.darkGray,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final reason = reasonController.text.trim();
              if (reason.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please provide a rejection reason'),
                    backgroundColor: AppColors.error,
                  ),
                );
                return;
              }
              Navigator.pop(ctx);
              _reject(docId, name, reason);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  // ─── UI ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WaveBackground(
        showGradient: false,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildFilterTabs(),
              Expanded(child: _buildApplicationsList()),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────
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
              icon:
                  const Icon(Icons.arrow_back, color: AppColors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Agent Applications', style: AppTextStyles.h3),
                Text(
                  'Manage agent verification requests',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textGray),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
            ),
            child:
                const Icon(Icons.badge, color: Colors.orange, size: 22),
          ),
        ],
      ),
    );
  }

  // ─── Filter Tabs ──────────────────────────────────────────────────────────
  Widget _buildFilterTabs() {
    final filters = [
      {'key': 'all', 'label': 'All', 'color': AppColors.primaryRed},
      {'key': 'pending', 'label': 'Pending', 'color': Colors.orange},
      {'key': 'approved', 'label': 'Approved', 'color': Colors.green},
      {'key': 'rejected', 'label': 'Rejected', 'color': AppColors.error},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: filters.map((f) {
          final isSelected = _selectedFilter == f['key'] as String;
          final color = f['color'] as Color;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FilterChip(
              selected: isSelected,
              label: Text(f['label'] as String),
              onSelected: (_) {
                setState(() => _selectedFilter = f['key'] as String);
              },
              backgroundColor: AppColors.darkGray,
              selectedColor: color,
              checkmarkColor: AppColors.white,
              labelStyle: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? AppColors.white : AppColors.textGray,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(
                  color: isSelected
                      ? color
                      : AppColors.mediumGray.withValues(alpha: 0.3),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── Applications List (Firestore StreamBuilder) ──────────────────────────
  Widget _buildApplicationsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _applicationsStream,
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryRed),
          );
        }

        // Error
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline,
                    color: AppColors.error, size: 48),
                const SizedBox(height: 12),
                Text('Failed to load applications',
                    style: AppTextStyles.h5),
                const SizedBox(height: 6),
                Text(
                  snapshot.error.toString(),
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textGray),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final docs = snapshot.data?.docs ?? [];

        // Empty state
        if (docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.inbox_outlined,
                      size: 56, color: Colors.orange),
                ),
                const SizedBox(height: 18),
                Text('No Applications', style: AppTextStyles.h4),
                const SizedBox(height: 6),
                Text(
                  _selectedFilter == 'all'
                      ? 'No agent applications yet.'
                      : 'No $_selectedFilter applications right now.',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textGray),
                ),
              ],
            ),
          );
        }

        // List
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Count banner
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: Colors.orange.withValues(alpha: 0.35)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.people_outline,
                      color: Colors.orange, size: 18),
                  const SizedBox(width: 10),
                  Text(
                    '${docs.length} application${docs.length == 1 ? '' : 's'}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  final data = doc.data() as Map<String, dynamic>;
                  return _buildApplicationCard(doc.id, data);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // ─── Application Card ─────────────────────────────────────────────────────
  Widget _buildApplicationCard(String docId, Map<String, dynamic> data) {
    final name = data['fullName'] as String? ?? 'Unknown';
    final nin = data['nin'] as String? ?? '—';
    final phone = data['phone'] as String? ?? '—';
    final email = data['email'] as String? ?? '—';
    final status = data['status'] as String? ?? 'pending';
    final passportUrl = data['passportUrl'] as String?;
    final submittedAt = data['submittedAt'] != null
        ? (data['submittedAt'] as Timestamp).toDate()
        : null;
    final address = data['address'] as String? ?? '—';
    final rejectionReason = data['rejectionReason'] as String?;

    final borderColor = status == 'approved'
        ? Colors.green
        : status == 'rejected'
            ? AppColors.error
            : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(22),
        border:
            Border.all(color: borderColor.withValues(alpha: 0.25), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Avatar + Name + Status Badge ──────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: passportUrl != null
                      ? Image.network(
                          passportUrl,
                          width: 54,
                          height: 54,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _avatarFallback(name),
                        )
                      : _avatarFallback(name),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: AppTextStyles.h5
                              .copyWith(color: AppColors.white)),
                      const SizedBox(height: 3),
                      Text(email,
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.textGray),
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                _buildStatusBadge(status),
              ],
            ),
          ),

          const Divider(color: AppColors.mediumGray, height: 1),

          // ── Key Details ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _detailTile(
                  icon: Icons.person_outline,
                  label: 'Full Name',
                  value: name,
                  highlight: true,
                ),
                const SizedBox(height: 10),
                _detailTile(
                  icon: Icons.badge_outlined,
                  label: 'NIN',
                  value: nin,
                  highlight: true,
                ),
                const SizedBox(height: 10),
                _detailTile(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: phone,
                  highlight: true,
                ),
                const SizedBox(height: 10),
                _detailTile(
                  icon: Icons.location_on_outlined,
                  label: 'Address',
                  value: address,
                ),
                if (submittedAt != null) ...[
                  const SizedBox(height: 10),
                  _detailTile(
                    icon: Icons.access_time,
                    label: 'Submitted',
                    value: _formatDate(submittedAt),
                  ),
                ],
                if (rejectionReason != null && rejectionReason.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            size: 16, color: AppColors.error),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            rejectionReason,
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

          // ── Action Buttons (only for pending) ─────────────────────────
          if (status == 'pending') ...[
            const Divider(color: AppColors.mediumGray, height: 1),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showRejectDialog(docId, name),
                      icon: const Icon(Icons.close, size: 15),
                      label: const Text('Reject'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _approve(docId, name),
                      icon: const Icon(Icons.check, size: 15),
                      label: const Text('Approve'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
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

  // ─── Status Badge ──────────────────────────────────────────────────────
  Widget _buildStatusBadge(String status) {
    Color color;
    String label;
    switch (status) {
      case 'approved':
        color = Colors.green;
        label = 'APPROVED';
        break;
      case 'rejected':
        color = AppColors.error;
        label = 'REJECTED';
        break;
      default:
        color = Colors.orange;
        label = 'PENDING';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 10,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  // ─── Detail Tile ─────────────────────────────────────────────────────────
  Widget _detailTile({
    required IconData icon,
    required String label,
    required String value,
    bool highlight = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: AppColors.primaryRed.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 15, color: AppColors.primaryRed),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textGray, fontSize: 11)),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: highlight ? AppColors.white : AppColors.lightGray,
                  fontWeight: highlight ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Avatar Fallback ──────────────────────────────────────────────────────
  Widget _avatarFallback(String name) {
    return Container(
      width: 54,
      height: 54,
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: AppTextStyles.h4.copyWith(color: AppColors.white),
        ),
      ),
    );
  }

  // ─── Date Format ──────────────────────────────────────────────────────────
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}
