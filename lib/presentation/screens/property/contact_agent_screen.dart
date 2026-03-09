import 'package:flutter/material.dart';
import 'package:nestify/core/widgets/wave_background.dart';
import 'package:nestify/core/widgets/animated_button.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';
import 'package:nestify/data/models/property_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactAgentScreen extends StatefulWidget {
  final PropertyModel property;

  const ContactAgentScreen({
    Key? key,
    required this.property,
  }) : super(key: key);

  @override
  State<ContactAgentScreen> createState() => _ContactAgentScreenState();
}

class _ContactAgentScreenState extends State<ContactAgentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  
  bool _isLoading = false;

  // Mock agent data
  final String agentName = 'Sarah Johnson';
  final String agentRole = 'Senior Property Agent';
  final String agentPhone = '+234 801 234 5678';
  final String agentEmail = 'sarah.johnson@nestify.com';
  final String agentWhatsApp = '+2348012345678';
  final String agentImage = 'https://i.pravatar.cc/150?img=5';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _makePhoneCall() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: agentPhone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: agentEmail,
      queryParameters: {
        'subject': 'Inquiry about ${widget.property.title}',
      },
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  Future<void> _openWhatsApp() async {
    final Uri whatsappUri = Uri.parse(
      'https://wa.me/$agentWhatsApp?text=Hi, I\'m interested in ${widget.property.title}',
    );
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _submitMessage() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message sent successfully!'),
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WaveBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPropertyInfo(),
                      const SizedBox(height: 24),
                      _buildAgentInfo(),
                      const SizedBox(height: 24),
                      _buildQuickActions(),
                      const SizedBox(height: 32),
                      _buildContactForm(),
                      const SizedBox(height: 20),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: AppColors.white),
          ),
          const SizedBox(width: 12),
          Text(
            'Contact Agent',
            style: AppTextStyles.h3,
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryRed.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(widget.property.images.first),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.property.title,
                  style: AppTextStyles.h5,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.property.location,
                  style: AppTextStyles.bodySmall.copyWith(
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

  Widget _buildAgentInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryRed.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 3),
              image: DecorationImage(
                image: NetworkImage(agentImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  agentName,
                  style: AppTextStyles.h4.copyWith(color: AppColors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  agentRole,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '4.9 (127 reviews)',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTextStyles.h5,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.phone,
                label: 'Call',
                color: AppColors.success,
                onTap: _makePhoneCall,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                icon: Icons.email,
                label: 'Email',
                color: AppColors.info,
                onTap: _sendEmail,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                icon: Icons.chat,
                label: 'WhatsApp',
                color: const Color(0xFF25D366),
                onTap: _openWhatsApp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Send a Message',
            style: AppTextStyles.h5,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Your Name',
              prefixIcon: Icon(Icons.person_outline, color: AppColors.primaryRed),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              hintText: 'Your Email',
              prefixIcon: Icon(Icons.email_outlined, color: AppColors.primaryRed),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              hintText: 'Your Phone',
              prefixIcon: Icon(Icons.phone_outlined, color: AppColors.primaryRed),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _messageController,
            decoration: const InputDecoration(
              hintText: 'Your Message',
              prefixIcon: Icon(Icons.message_outlined, color: AppColors.primaryRed),
            ),
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your message';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          GradientAnimatedButton(
            text: 'Send Message',
            onPressed: _submitMessage,
            isLoading: _isLoading,
            icon: Icons.send,
            width: double.infinity,
            gradient: AppColors.primaryGradient,
          ),
        ],
      ),
    );
  }
}
