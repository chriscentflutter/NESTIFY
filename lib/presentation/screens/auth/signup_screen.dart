import 'package:flutter/material.dart';
import 'package:nestify/core/widgets/wave_background.dart';
import 'package:nestify/core/widgets/custom_button.dart';
import 'package:nestify/core/widgets/custom_text_field.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';
import 'package:nestify/data/models/agent_application.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Agent-only fields
  final _addressController = TextEditingController();
  final _ninController = TextEditingController();
  String? _passportImagePath; // local placeholder — file picker can be hooked up later

  bool _isLoading = false;
  bool _agreedToTerms = false;
  String _selectedRole = 'seeker'; // 'seeker' or 'agent'

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    _ninController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WaveBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),

                  // Back Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  Text(
                    'Create Account',
                    style: AppTextStyles.h2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Join us to find your perfect property',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.lightGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Role Selection
                  Text(
                    'I am a:',
                    style: AppTextStyles.label,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildRoleCard(
                          'Property Seeker',
                          'seeker',
                          Icons.search,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildRoleCard(
                          'Agent/Owner',
                          'agent',
                          Icons.business,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Agent info banner
                  if (_selectedRole == 'agent') ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.primaryRed.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: AppColors.primaryRed,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Agent accounts require verification. Your application will be reviewed within 24–48 hours.',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.lightGray,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Full Name
                  CustomTextField(
                    controller: _nameController,
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    prefixIcon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Email
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'Enter your email',
                    prefixIcon: Icons.email,
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
                  const SizedBox(height: 20),

                  // Phone
                  CustomTextField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    hint: 'Enter your phone number',
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // ─── Agent-only fields ───────────────────────────────────
                  if (_selectedRole == 'agent') ...[
                    // Address
                    CustomTextField(
                      controller: _addressController,
                      label: 'Home Address',
                      hint: 'Enter your residential address',
                      prefixIcon: Icons.location_on,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // NIN
                    CustomTextField(
                      controller: _ninController,
                      label: 'NIN (National ID Number)',
                      hint: 'Enter your 11-digit NIN',
                      prefixIcon: Icons.badge,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your NIN';
                        }
                        if (value.length < 11) {
                          return 'NIN must be 11 digits';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Passport / ID Photo
                    _buildPassportUploadField(),
                    const SizedBox(height: 20),
                  ],
                  // ────────────────────────────────────────────────────────

                  // Password
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Enter your password',
                    prefixIcon: Icons.lock,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Confirm Password
                  CustomTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    hint: 'Re-enter your password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Terms and Conditions
                  Row(
                    children: [
                      Checkbox(
                        value: _agreedToTerms,
                        onChanged: (value) {
                          setState(() {
                            _agreedToTerms = value ?? false;
                          });
                        },
                        activeColor: AppColors.primaryRed,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _agreedToTerms = !_agreedToTerms;
                            });
                          },
                          child: Text.rich(
                            TextSpan(
                              text: 'I agree to the ',
                              style: AppTextStyles.bodySmall,
                              children: [
                                TextSpan(
                                  text: 'Terms & Conditions',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.primaryRed,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.primaryRed,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Sign Up Button
                  GradientButton(
                    text: 'Sign Up',
                    onPressed: _agreedToTerms ? _handleSignup : () {},
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 24),

                  // Divider
                  Row(
                    children: [
                      const Expanded(child: Divider(color: AppColors.mediumGray)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                      const Expanded(child: Divider(color: AppColors.mediumGray)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Social Signup Buttons
                  CustomButton(
                    text: 'Continue with Google',
                    onPressed: _handleGoogleSignup,
                    icon: Icons.g_mobiledata,
                    backgroundColor: AppColors.white,
                    textColor: AppColors.richBlack,
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Continue with Apple',
                    onPressed: _handleAppleSignup,
                    icon: Icons.apple,
                    backgroundColor: AppColors.charcoal,
                  ),
                  const SizedBox(height: 32),

                  // Sign In Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: AppTextStyles.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Sign In',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primaryRed,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPassportUploadField() {
    return GestureDetector(
      onTap: () {
        // Simulate picking a passport image
        setState(() {
          _passportImagePath = 'selected'; // placeholder
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passport/ID photo selected'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.darkGray,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _passportImagePath != null
                ? AppColors.primaryRed
                : AppColors.mediumGray,
            width: _passportImagePath != null ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _passportImagePath != null
                    ? AppColors.primaryRed
                    : AppColors.mediumGray,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _passportImagePath != null
                    ? Icons.check
                    : Icons.camera_alt_outlined,
                color: AppColors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _passportImagePath != null
                        ? 'Passport / ID Uploaded ✓'
                        : 'Upload Passport / ID Photo',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: _passportImagePath != null
                          ? AppColors.white
                          : AppColors.textGray,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _passportImagePath != null
                        ? 'Tap to change photo'
                        : 'Tap to upload a clear photo of your ID',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textGray,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard(String title, String role, IconData icon) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryRed : AppColors.darkGray,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.crimson : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.white,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      if (!_agreedToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please agree to the terms and conditions'),
          ),
        );
        return;
      }

      // Validate agent-specific fields
      if (_selectedRole == 'agent') {
        if (_passportImagePath == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please upload your passport / ID photo'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }
      }

      setState(() {
        _isLoading = true;
      });

      // Simulate signup API call
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });

        if (_selectedRole == 'agent') {
          // Save agent application to shared store
          final application = AgentApplication(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            fullName: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            address: _addressController.text.trim(),
            nin: _ninController.text.trim(),
            passportImagePath: _passportImagePath,
            submittedAt: DateTime.now(),
          );
          AgentApplicationStore.add(application);

          // Show "Under Review" dialog
          _showApplicationUnderReviewDialog();
        } else {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      });
    }
  }

  void _showApplicationUnderReviewDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppColors.charcoal,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.primaryRed.withValues(alpha: 0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryRed.withValues(alpha: 0.15),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryRed.withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.hourglass_top_rounded,
                  color: AppColors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Application Submitted!',
                style: AppTextStyles.h4.copyWith(
                  color: AppColors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Your agent application is currently under review. Our team will verify your details within 24–48 hours. You will be notified once it\'s approved.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.lightGray,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Details summary
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: AppColors.darkGray,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _dialogDetailRow(Icons.person, _nameController.text.trim()),
                    const SizedBox(height: 6),
                    _dialogDetailRow(Icons.phone, _phoneController.text.trim()),
                    const SizedBox(height: 6),
                    _dialogDetailRow(Icons.badge, 'NIN: ${_ninController.text.trim()}'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    Navigator.of(context).pushReplacementNamed('/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Continue to App',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dialogDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.primaryRed),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.lightGray),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _handleGoogleSignup() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google signup coming soon')),
    );
  }

  void _handleAppleSignup() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Apple signup coming soon')),
    );
  }
}
