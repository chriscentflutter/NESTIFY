import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nestify/core/widgets/wave_background.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({Key? key}) : super(key: key);

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  late final FirebaseFirestore _firestore;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot> get _usersStream => _firestore
      .collection('users')
      .orderBy('createdAt', descending: true)
      .snapshots();

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
              _buildSearchBar(),
              Expanded(child: _buildUsersList()),
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
                Text('All Users', style: AppTextStyles.h3),
                Text(
                  'Registered app users',
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
            child: const Icon(Icons.people, color: AppColors.white, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
        style: AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          hintText: 'Search by name or email...',
          hintStyle:
              AppTextStyles.bodyMedium.copyWith(color: AppColors.textGray),
          prefixIcon:
              const Icon(Icons.search, color: AppColors.textGray, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close,
                      color: AppColors.textGray, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          filled: true,
          fillColor: AppColors.charcoal,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildUsersList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryRed),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline,
                    color: AppColors.error, size: 48),
                const SizedBox(height: 12),
                Text('Failed to load users', style: AppTextStyles.h5),
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

        final allDocs = snapshot.data?.docs ?? [];

        // Filter by search
        final docs = _searchQuery.isEmpty
            ? allDocs
            : allDocs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final name =
                    (data['fullName'] ?? data['name'] ?? '').toString().toLowerCase();
                final email = (data['email'] ?? '').toString().toLowerCase();
                return name.contains(_searchQuery) ||
                    email.contains(_searchQuery);
              }).toList();

        if (allDocs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.people_outline,
                      size: 56, color: AppColors.primaryRed),
                ),
                const SizedBox(height: 18),
                Text('No Users Yet', style: AppTextStyles.h4),
                const SizedBox(height: 6),
                Text(
                  'Users will appear here once they register.',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textGray),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats banner
            _buildStatsBanner(allDocs.length, docs.length),
            Expanded(
              child: docs.isEmpty
                  ? Center(
                      child: Text(
                        'No users matching "$_searchQuery"',
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.textGray),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        final data = doc.data() as Map<String, dynamic>;
                        return _buildUserCard(doc.id, data);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatsBanner(int total, int showing) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryRed.withValues(alpha: 0.15),
            AppColors.crimson.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primaryRed.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.people, color: AppColors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$total Total Users',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (_searchQuery.isNotEmpty)
                Text(
                  '$showing matching results',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textGray),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(String docId, Map<String, dynamic> data) {
    final name = (data['fullName'] ?? data['name'] ?? 'Unknown').toString();
    final email = (data['email'] ?? '—').toString();
    final phone = (data['phone'] ?? data['phoneNumber'] ?? '—').toString();
    final role = (data['role'] ?? 'user').toString();
    final createdAt = data['createdAt'] != null
        ? (data['createdAt'] as Timestamp).toDate()
        : null;
    final photoUrl = data['photoUrl'] as String?;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.mediumGray.withValues(alpha: 0.25),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding:
              const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: _buildAvatar(name, photoUrl),
          title: Text(
            name,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            email,
            style:
                AppTextStyles.bodySmall.copyWith(color: AppColors.textGray),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: _buildRoleBadge(role),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(color: AppColors.mediumGray, height: 16),
            _detailRow(Icons.email_outlined, 'Email', email),
            const SizedBox(height: 8),
            _detailRow(Icons.phone_outlined, 'Phone', phone),
            const SizedBox(height: 8),
            _detailRow(Icons.badge_outlined, 'Role', role.toUpperCase()),
            if (createdAt != null) ...[
              const SizedBox(height: 8),
              _detailRow(
                  Icons.calendar_today, 'Joined', _formatDate(createdAt)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String name, String? photoUrl) {
    if (photoUrl != null && photoUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 22,
        backgroundImage: NetworkImage(photoUrl),
        onBackgroundImageError: (_, __) {},
        child: null,
      );
    }
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildRoleBadge(String role) {
    final isAgent = role.toLowerCase() == 'agent';
    final isAdmin = role.toLowerCase() == 'admin';
    final Color badgeColor =
        isAdmin ? AppColors.primaryRed : isAgent ? Colors.orange : Colors.teal;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
      ),
      child: Text(
        role.toUpperCase(),
        style: AppTextStyles.bodySmall.copyWith(
          color: badgeColor,
          fontWeight: FontWeight.bold,
          fontSize: 10,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.primaryRed.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 14, color: AppColors.primaryRed),
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
                  color: AppColors.lightGray,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
