import 'package:flutter/material.dart';
import 'package:nestify/core/widgets/wave_background.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _propertyUpdates = true;
  bool _priceAlerts = false;
  bool _newListings = true;
  bool _messages = true;
  bool _promotions = false;

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
                    Text('Notifications', style: AppTextStyles.h3),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // General Section
                      _buildSectionHeader(
                        icon: Icons.notifications_active,
                        title: 'General',
                      ),
                      const SizedBox(height: 12),
                      
                      _buildNotificationTile(
                        icon: Icons.notifications,
                        title: 'Push Notifications',
                        subtitle: 'Receive push notifications on your device',
                        value: _pushNotifications,
                        onChanged: (value) {
                          setState(() => _pushNotifications = value);
                        },
                      ),
                      
                      _buildNotificationTile(
                        icon: Icons.email,
                        title: 'Email Notifications',
                        subtitle: 'Receive notifications via email',
                        value: _emailNotifications,
                        onChanged: (value) {
                          setState(() => _emailNotifications = value);
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Property Updates Section
                      _buildSectionHeader(
                        icon: Icons.home_work,
                        title: 'Property Updates',
                      ),
                      const SizedBox(height: 12),
                      
                      _buildNotificationTile(
                        icon: Icons.update,
                        title: 'Property Updates',
                        subtitle: 'Get notified about property status changes',
                        value: _propertyUpdates,
                        onChanged: (value) {
                          setState(() => _propertyUpdates = value);
                        },
                      ),
                      
                      _buildNotificationTile(
                        icon: Icons.trending_down,
                        title: 'Price Alerts',
                        subtitle: 'Notify me when prices drop',
                        value: _priceAlerts,
                        onChanged: (value) {
                          setState(() => _priceAlerts = value);
                        },
                      ),
                      
                      _buildNotificationTile(
                        icon: Icons.fiber_new,
                        title: 'New Listings',
                        subtitle: 'Get alerts for new properties in your area',
                        value: _newListings,
                        onChanged: (value) {
                          setState(() => _newListings = value);
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Communication Section
                      _buildSectionHeader(
                        icon: Icons.chat_bubble,
                        title: 'Communication',
                      ),
                      const SizedBox(height: 12),
                      
                      _buildNotificationTile(
                        icon: Icons.message,
                        title: 'Messages',
                        subtitle: 'Notifications for new messages from agents',
                        value: _messages,
                        onChanged: (value) {
                          setState(() => _messages = value);
                        },
                      ),
                      
                      _buildNotificationTile(
                        icon: Icons.local_offer,
                        title: 'Promotions',
                        subtitle: 'Special offers and promotional content',
                        value: _promotions,
                        onChanged: (value) {
                          setState(() => _promotions = value);
                        },
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

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: AppTextStyles.h5,
        ),
      ],
    );
  }

  Widget _buildNotificationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: value 
              ? AppColors.primaryRed.withValues(alpha: 0.5)
              : AppColors.mediumGray.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: value 
                  ? AppColors.primaryRed.withValues(alpha: 0.2)
                  : AppColors.darkGray,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: value ? AppColors.primaryRed : AppColors.textGray,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textGray,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryRed,
            activeTrackColor: AppColors.primaryRed.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}
