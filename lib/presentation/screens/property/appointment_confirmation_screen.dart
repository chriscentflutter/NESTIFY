import 'package:flutter/material.dart';
import 'package:nestify/core/widgets/wave_background.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';
import 'package:nestify/data/models/property_model.dart';

class AppointmentConfirmationScreen extends StatefulWidget {
  final PropertyModel property;
  final String visitorName;
  final DateTime appointmentDate;
  final String appointmentTime;
 
  const AppointmentConfirmationScreen({
    Key? key,
    required this.property,
    required this.visitorName,
    required this.appointmentDate,
    required this.appointmentTime,
  }) : super(key: key);

  @override
  State<AppointmentConfirmationScreen> createState() =>
      _AppointmentConfirmationScreenState();
}

class _AppointmentConfirmationScreenState
    extends State<AppointmentConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));

    _scaleAnim = CurvedAnimation(
        parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.elasticOut));
    _fadeAnim = CurvedAnimation(
        parent: _controller, curve: const Interval(0.4, 1.0, curve: Curves.easeOut));
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut)));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WaveBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Close button at top right
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.darkGray,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: AppColors.white),
                      onPressed: () {
                        // Pop all the way back to property detail
                        Navigator.of(context).popUntil(
                          (route) => route.settings.name == '/property-detail' ||
                              route.isFirst,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Animated success icon
                      ScaleTransition(
                        scale: _scaleAnim,
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.primaryGradient,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryRed.withValues(alpha: 0.45),
                                blurRadius: 30,
                                spreadRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: AppColors.white,
                            size: 58,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      FadeTransition(
                        opacity: _fadeAnim,
                        child: SlideTransition(
                          position: _slideAnim,
                          child: Column(
                            children: [
                              // Celebration text
                              Text(
                                'Appointment Booked!',
                                style: AppTextStyles.h2.copyWith(
                                  color: AppColors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Your appointment has been confirmed.\nWe\'ll notify you with a reminder before your visit.',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.lightGray,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),
                              // Booking details card
                              _buildDetailsCard(),
                              const SizedBox(height: 24),
                              // Payment confirmed badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: AppColors.success.withValues(alpha: 0.4),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.check_circle,
                                        color: AppColors.success, size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      '₦5,000 Payment Confirmed',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.success,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),
                              // Action buttons
                              SizedBox(
                                width: double.infinity,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: AppColors.primaryGradient,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primaryRed
                                            .withValues(alpha: 0.35),
                                        blurRadius: 14,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Return to property detail - the call agent button will now show
                                      Navigator.of(context).popUntil(
                                        (route) =>
                                            route.settings.name ==
                                                '/property-detail' ||
                                            route.isFirst,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: Text(
                                      'View Property & Call Agent',
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () =>
                                      Navigator.of(context).pushNamedAndRemoveUntil(
                                          '/home', (r) => false),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.white,
                                    side: BorderSide(
                                        color: AppColors.mediumGray),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Text(
                                    'Go to Home',
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
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

  Widget _buildDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryRed.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Details',
            style: AppTextStyles.h5.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 16),
          _detailItem(Icons.home_work_outlined, 'Property',
              widget.property.title),
          const Divider(color: AppColors.mediumGray, height: 20),
          _detailItem(Icons.location_on_outlined, 'Location',
              '${widget.property.location}, ${widget.property.city}'),
          const Divider(color: AppColors.mediumGray, height: 20),
          _detailItem(Icons.person_outline, 'Visitor', widget.visitorName),
          const Divider(color: AppColors.mediumGray, height: 20),
          _detailItem(Icons.calendar_today_outlined, 'Date',
              _formatDate(widget.appointmentDate)),
          const Divider(color: AppColors.mediumGray, height: 20),
          _detailItem(Icons.access_time, 'Time', widget.appointmentTime),
          const Divider(color: AppColors.mediumGray, height: 20),
          _detailItem(Icons.supervisor_account_outlined, 'Agent',
              widget.property.agentName),
        ],
      ),
    );
  }

  Widget _detailItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primaryRed.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryRed, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textGray),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return '${days[d.weekday - 1]}, ${months[d.month]} ${d.day}, ${d.year}';
  }
}
