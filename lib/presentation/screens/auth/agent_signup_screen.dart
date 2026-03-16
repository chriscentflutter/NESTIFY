import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';
import 'package:nestify/core/widgets/wave_background.dart';

class AgentSignupScreen extends StatefulWidget {
  const AgentSignupScreen({Key? key}) : super(key: key);

  @override
  State<AgentSignupScreen> createState() => _AgentSignupScreenState();
}

class _AgentSignupScreenState extends State<AgentSignupScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _ninController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  File? _passportFile;
  String? _passportFileName;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;



  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _ninController.dispose();
    _animController.dispose();
    super.dispose();
  }

  // ─── Pick Passport/ID Document ────────────────────────────────────────────────────
  Future<void> _pickPassport() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _passportFile = File(result.files.single.path!);
          _passportFileName = result.files.single.name;
        });
      }
    } catch (e) {
      if (mounted) {
        _showError('Error picking file: $e');
      }
    }
  }

  // ─── Main Submit Handler ─────────────────────────────────────────────────────
  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passportFile == null) {
      _showError('Please upload your Passport / ID photo.');
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API request delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Show "Under Review" dialog
    await _showUnderReviewDialog();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(Icons.error_outline, color: AppColors.white, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(msg)),
        ]),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _showUnderReviewDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppColors.charcoal,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
                color: AppColors.primaryRed.withValues(alpha: 0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryRed.withValues(alpha: 0.15),
                blurRadius: 30,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated icon
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryRed.withValues(alpha: 0.45),
                      blurRadius: 24,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.hourglass_top_rounded,
                  color: AppColors.white,
                  size: 44,
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Application Under Review',
                style: AppTextStyles.h4.copyWith(color: AppColors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.darkGray,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'Your application is under review. Our team will verify your details shortly.\n\nYou will be notified once a decision is made.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.lightGray,
                    height: 1.55,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
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
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // close dialog
                      // Navigate to Review Status screen, remove all previous routes
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/agent-review-status',
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'View Application Status',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
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

  // ─── UI ──────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WaveBackground(
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Back button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.darkGray,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: AppColors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Header
                    Center(
                      child: Container(
                        width: 72,
                        height: 72,
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
                        child: const Icon(Icons.badge,
                            color: AppColors.white, size: 36),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Agent Registration',
                      style: AppTextStyles.h2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Complete your KYC to list properties on Nestify',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textGray),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),

                    // ── KYC Info Banner ───────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: AppColors.primaryRed.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.verified_user_outlined,
                              color: AppColors.primaryRed, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Your details will be verified by our team before activation.',
                              style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.lightGray, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Section: Personal Info ────────────────────────────
                    _sectionLabel('Personal Information'),
                    const SizedBox(height: 14),
                    _field(
                      controller: _nameController,
                      hint: 'Full Name',
                      icon: Icons.person_outline,
                      validator: (v) =>
                          v!.isEmpty ? 'Enter your full name' : null,
                    ),
                    const SizedBox(height: 14),
                    _field(
                      controller: _emailController,
                      hint: 'Email Address',
                      icon: Icons.email_outlined,
                      keyboard: TextInputType.emailAddress,
                      validator: (v) {
                        if (v!.isEmpty) return 'Enter your email';
                        if (!v.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    _field(
                      controller: _phoneController,
                      hint: 'Phone Number',
                      icon: Icons.phone_outlined,
                      keyboard: TextInputType.phone,
                      validator: (v) {
                        if (v!.isEmpty) return 'Enter your phone number';
                        if (v.length < 10) return 'Enter a valid phone number';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: AppColors.primaryRed),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.textGray,
                          ),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      validator: (v) {
                        if (v!.isEmpty) return 'Enter a password';
                        if (v.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),

                    // ── Section: KYC Details ──────────────────────────────
                    _sectionLabel('KYC Verification Details'),
                    const SizedBox(height: 14),
                    _field(
                      controller: _addressController,
                      hint: 'Home Address',
                      icon: Icons.location_on_outlined,
                      maxLines: 2,
                      validator: (v) =>
                          v!.isEmpty ? 'Enter your home address' : null,
                    ),
                    const SizedBox(height: 14),
                    _field(
                      controller: _ninController,
                      hint: 'NIN (National ID Number)',
                      icon: Icons.badge_outlined,
                      keyboard: TextInputType.number,
                      validator: (v) {
                        if (v!.isEmpty) return 'Enter your NIN';
                        if (v.length < 11) return 'NIN must be 11 digits';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // ── Passport Upload ───────────────────────────────────
                    _sectionLabel('Passport / ID Photo'),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _pickPassport,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: 150,
                        decoration: BoxDecoration(
                          color: _passportFile != null
                              ? Colors.transparent
                              : AppColors.darkGray,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: _passportFile != null
                                ? AppColors.primaryRed
                                : AppColors.mediumGray,
                            width: _passportFile != null ? 2 : 1.5,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: _passportFile != null
                            ? Stack(
                                fit: StackFit.expand,
                                children: [
                                  // Show image if it's an image, else show file icon
                                  _passportFileName!.toLowerCase().endsWith('.pdf')
                                      ? const Center(
                                          child: Icon(Icons.picture_as_pdf, color: AppColors.primaryRed, size: 48),
                                        )
                                      : ClipRRect(
                                          borderRadius: BorderRadius.circular(17),
                                          child: Image.file(_passportFile!, fit: BoxFit.cover),
                                        ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        color: AppColors.primaryRed,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.check,
                                          color: AppColors.white,
                                          size: 14),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black.withValues(alpha: 0.7),
                                            Colors.transparent,
                                          ],
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(17),
                                          bottomRight: Radius.circular(17),
                                        ),
                                      ),
                                      child: Text(
                                        _passportFileName ?? 'Tap to change',
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.bodySmall
                                            .copyWith(
                                                color: AppColors.white),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryRed
                                          .withValues(alpha: 0.12),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                        Icons.cloud_upload_outlined,
                                        color: AppColors.primaryRed,
                                        size: 30),
                                  ),
                                  const SizedBox(height: 10),
                                  Text('Upload Passport or ID Photo',
                                      style: AppTextStyles.bodyMedium),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Tap to select from camera or gallery',
                                    style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textGray),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── Submit Button ─────────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: _isLoading
                              ? null
                              : AppColors.primaryGradient,
                          color: _isLoading ? AppColors.mediumGray : null,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: _isLoading
                              ? []
                              : [
                                  BoxShadow(
                                    color: AppColors.primaryRed
                                        .withValues(alpha: 0.4),
                                    blurRadius: 18,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitApplication,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding:
                                const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: AppColors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.send_rounded,
                                        color: AppColors.white, size: 18),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Submit Application',
                                      style: AppTextStyles.bodyLarge
                                          .copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Already have account?
                    Center(
                      child: TextButton(
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, '/login'),
                        child: RichText(
                          text: TextSpan(
                            style: AppTextStyles.bodyMedium,
                            children: [
                              TextSpan(
                                text: 'Already registered? ',
                                style: TextStyle(color: AppColors.textGray),
                              ),
                              TextSpan(
                                text: 'Log In',
                                style: TextStyle(
                                  color: AppColors.primaryRed,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────
  Widget _sectionLabel(String label) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(label,
            style: AppTextStyles.h5.copyWith(color: AppColors.white)),
      ],
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primaryRed),
      ),
      validator: validator,
    );
  }
}
