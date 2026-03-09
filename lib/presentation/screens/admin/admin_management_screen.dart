import 'package:flutter/material.dart';
import 'package:nestify/core/widgets/wave_background.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';

class AdminManagementScreen extends StatefulWidget {
  const AdminManagementScreen({Key? key}) : super(key: key);

  @override
  State<AdminManagementScreen> createState() => _AdminManagementScreenState();
}

class _AdminManagementScreenState extends State<AdminManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Mock admin data - replace with actual API call
  final List<AdminUser> _admins = [
    AdminUser(
      id: '1',
      name: 'John Doe',
      email: 'john.doe@nestify.com',
      role: 'Super Admin',
      addedAt: DateTime.now().subtract(const Duration(days: 30)),
      isActive: true,
    ),
    AdminUser(
      id: '2',
      name: 'Jane Smith',
      email: 'jane.smith@nestify.com',
      role: 'Admin',
      addedAt: DateTime.now().subtract(const Duration(days: 15)),
      isActive: true,
    ),
    AdminUser(
      id: '3',
      name: 'Mike Johnson',
      email: 'mike.j@nestify.com',
      role: 'Admin',
      addedAt: DateTime.now().subtract(const Duration(days: 7)),
      isActive: false,
    ),
  ];

  List<AdminUser> get _filteredAdmins {
    if (_searchQuery.isEmpty) {
      return _admins;
    }
    return _admins.where((admin) {
      return admin.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          admin.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          admin.role.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
              _buildStats(),
              Expanded(
                child: _buildAdminsList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddAdminDialog,
        backgroundColor: AppColors.primaryRed,
        icon: const Icon(Icons.person_add),
        label: const Text('Add Admin'),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: AppColors.white),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.charcoal,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin Management',
                  style: AppTextStyles.h3,
                ),
                Text(
                  'Manage admin users',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search admins...',
          prefixIcon: const Icon(Icons.search, color: AppColors.textGray),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textGray),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: AppColors.charcoal,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        style: AppTextStyles.bodyMedium,
      ),
    );
  }

  Widget _buildStats() {
    final activeCount = _admins.where((a) => a.isActive).length;
    final inactiveCount = _admins.where((a) => !a.isActive).length;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              label: 'Total Admins',
              value: _admins.length.toString(),
              color: AppColors.primaryRed,
              icon: Icons.people,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              label: 'Active',
              value: activeCount.toString(),
              color: Colors.green,
              icon: Icons.check_circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              label: 'Inactive',
              value: inactiveCount.toString(),
              color: Colors.orange,
              icon: Icons.pause_circle,
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
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAdminsList() {
    if (_filteredAdmins.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_off,
              size: 64,
              color: AppColors.textGray,
            ),
            const SizedBox(height: 16),
            Text(
              'No Admins Found',
              style: AppTextStyles.h5,
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isEmpty
                  ? 'Add your first admin'
                  : 'Try a different search',
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
      itemCount: _filteredAdmins.length,
      itemBuilder: (context, index) {
        final admin = _filteredAdmins[index];
        return _buildAdminCard(admin);
      },
    );
  }

  Widget _buildAdminCard(AdminUser admin) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.mediumGray.withValues(alpha: 0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  admin.name.split(' ').map((e) => e[0]).take(2).join(),
                  style: AppTextStyles.h5.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          admin.name,
                          style: AppTextStyles.h5,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildStatusBadge(admin.isActive),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    admin.email,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textGray,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryRed.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          admin.role,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primaryRed,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Added ${_formatDate(admin.addedAt)}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textGray,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Actions
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppColors.white),
              color: AppColors.charcoal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              onSelected: (value) {
                if (value == 'toggle') {
                  _toggleAdminStatus(admin);
                } else if (value == 'remove') {
                  _showRemoveAdminDialog(admin);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'toggle',
                  child: Row(
                    children: [
                      Icon(
                        admin.isActive ? Icons.pause : Icons.play_arrow,
                        size: 20,
                        color: AppColors.white,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        admin.isActive ? 'Deactivate' : 'Activate',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'remove',
                  child: Row(
                    children: [
                      const Icon(
                        Icons.delete,
                        size: 20,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Remove',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isActive ? Colors.green : Colors.orange).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (isActive ? Colors.green : Colors.orange).withValues(alpha: 0.5),
        ),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: AppTextStyles.bodySmall.copyWith(
          color: isActive ? Colors.green : Colors.orange,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 1) {
      return 'today';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else {
      return '${(difference.inDays / 30).floor()}mo ago';
    }
  }

  void _showAddAdminDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    String selectedRole = 'Admin';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.charcoal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: Text('Add New Admin', style: AppTextStyles.h5),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter admin details:',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.lightGray,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'John Doe',
                    filled: true,
                    fillColor: AppColors.darkGray,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'john.doe@nestify.com',
                    filled: true,
                    fillColor: AppColors.darkGray,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: InputDecoration(
                    labelText: 'Role',
                    filled: true,
                    fillColor: AppColors.darkGray,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  dropdownColor: AppColors.charcoal,
                  style: AppTextStyles.bodyMedium,
                  items: ['Super Admin', 'Admin', 'Moderator']
                      .map((role) => DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedRole = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty ||
                    emailController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all fields'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  return;
                }

                setState(() {
                  _admins.add(AdminUser(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text.trim(),
                    email: emailController.text.trim(),
                    role: selectedRole,
                    addedAt: DateTime.now(),
                    isActive: true,
                  ));
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${nameController.text} added as admin'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Add Admin'),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleAdminStatus(AdminUser admin) {
    setState(() {
      final index = _admins.indexWhere((a) => a.id == admin.id);
      _admins[index] = admin.copyWith(isActive: !admin.isActive);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${admin.name} ${admin.isActive ? 'deactivated' : 'activated'}',
        ),
        backgroundColor: admin.isActive ? Colors.orange : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showRemoveAdminDialog(AdminUser admin) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.charcoal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        title: Text('Remove Admin', style: AppTextStyles.h5),
        content: Text(
          'Are you sure you want to remove ${admin.name}? This action cannot be undone.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.lightGray,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _admins.removeWhere((a) => a.id == admin.id);
              });

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${admin.name} removed'),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}

// Admin User Model
class AdminUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final DateTime addedAt;
  final bool isActive;

  AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.addedAt,
    required this.isActive,
  });

  AdminUser copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    DateTime? addedAt,
    bool? isActive,
  }) {
    return AdminUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      addedAt: addedAt ?? this.addedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
