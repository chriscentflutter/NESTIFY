import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nestify/core/providers/theme_provider.dart';
import 'package:nestify/core/widgets/wave_background.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';
import 'package:nestify/presentation/screens/property/listing_plans_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WaveBackground(
        showGradient: false,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildProfileHeader(),
                const SizedBox(height: 32),
                _buildStatsSection(),
                const SizedBox(height: 24),
                _buildPreferencesSection(),
                const SizedBox(height: 24),
                _buildSettingsSection(context),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        // Avatar with gradient border
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryRed.withValues(alpha: 0.4),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.charcoal,
            ),
            child: Center(
              child: Text(
                'JD',
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Name
        Text(
          'John Doe',
          style: AppTextStyles.h3,
        ),
        const SizedBox(height: 4),
        
        // Email with icon
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.email_outlined,
              size: 16,
              color: AppColors.textGray,
            ),
            const SizedBox(width: 6),
            Text(
              'john.doe@example.com',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textGray,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Edit Profile Button with gradient
        Container(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryRed.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Navigate to edit profile
            },
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Edit Profile'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.visibility_outlined,
              label: 'Viewed',
              value: '24',
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryRed.withValues(alpha: 0.2),
                  AppColors.crimson.withValues(alpha: 0.1),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.favorite_outline,
              label: 'Favorites',
              value: '8',
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryRed.withValues(alpha: 0.2),
                  AppColors.crimson.withValues(alpha: 0.1),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.description_outlined,
              label: 'Applications',
              value: '3',
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryRed.withValues(alpha: 0.2),
                  AppColors.crimson.withValues(alpha: 0.1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Gradient gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryRed.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryRed, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.h4,
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

  Widget _buildPreferencesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.tune,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Preferences',
                style: AppTextStyles.h5,
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Theme Toggle
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              final isDarkMode = themeProvider.isDarkMode;
              
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.charcoal,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: AppColors.mediumGray.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        color: AppColors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isDarkMode ? 'Dark Mode' : 'Light Mode',
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isDarkMode ? 'Enabled' : 'Disabled',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: isDarkMode,
                      onChanged: (value) {
                        themeProvider.toggleTheme();
                      },
                      activeColor: AppColors.primaryRed,
                      activeTrackColor: AppColors.primaryRed.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              );
            },
          ),
          
          const SizedBox(height: 12),
          
          // Language Selection
          Container(
            padding: const EdgeInsets.all(16),
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
                      child: const Icon(
                        Icons.language,
                        color: AppColors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Language',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Language Options
                _buildLanguageOption('🇬🇧', 'English'),
                const SizedBox(height: 8),
                _buildLanguageOption('🇫🇷', 'French'),
                const SizedBox(height: 8),
                _buildLanguageOption('🇪🇸', 'Spanish'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String flag, String language) {
    final isSelected = _selectedLanguage == language;
    
    return InkWell(
      onTap: () {
        setState(() => _selectedLanguage = language);
        // TODO: Implement language switching
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primaryRed.withValues(alpha: 0.2)
              : AppColors.darkGray,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryRed
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                language,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? AppColors.white : AppColors.lightGray,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primaryRed,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.settings,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Settings',
                style: AppTextStyles.h5,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        _buildSettingsTile(
          icon: Icons.notifications_active_outlined,
          title: 'Notifications',
          subtitle: 'Manage notification preferences',
          onTap: () {
            Navigator.pushNamed(context, '/notifications');
          },
        ),
        
        _buildSettingsTile(
          icon: Icons.shield_outlined,
          title: 'Privacy & Security',
          subtitle: 'Password, security settings',
          onTap: () {
            Navigator.pushNamed(context, '/privacy-policy');
          },
        ),
        
        _buildSettingsTile(
          icon: Icons.help_outline_outlined,
          title: 'Help & Support',
          subtitle: 'FAQs, contact support',
          onTap: () {
            Navigator.pushNamed(context, '/help-support');
          },
        ),
        
        _buildSettingsTile(
          icon: Icons.info_outline,
          title: 'About',
          subtitle: 'App version, terms & conditions',
          onTap: () {
            Navigator.pushNamed(context, '/about');
          },
        ),
        
        _buildSettingsTile(
          icon: Icons.add_home_work_outlined,
          title: 'List a Property',
          subtitle: 'Choose a plan and list your property',
          iconColor: const Color(0xFF7C3AED),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ListingPlansScreen(),
              ),
            );
          },
        ),
        
        _buildSettingsTile(
          icon: Icons.admin_panel_settings_outlined,
          title: 'Admin Dashboard',
          subtitle: 'Manage property approvals',
          iconColor: AppColors.primaryRed,
          onTap: () {
            Navigator.pushNamed(context, '/admin-dashboard');
          },
        ),
        
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Divider(color: AppColors.mediumGray),
        ),
        
        _buildSettingsTile(
          icon: Icons.logout_outlined,
          title: 'Logout',
          subtitle: 'Sign out of your account',
          iconColor: AppColors.error,
          onTap: () {
            _showLogoutConfirmation(context);
          },
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: iconColor == null ? AppColors.primaryGradient : null,
          color: iconColor != null ? AppColors.darkGray : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: iconColor ?? AppColors.white,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textGray,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textGray,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.charcoal,
        title: Text('Logout', style: AppTextStyles.h5),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.lightGray),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement logout logic
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
