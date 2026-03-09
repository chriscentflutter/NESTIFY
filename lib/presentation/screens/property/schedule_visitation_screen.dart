import 'package:flutter/material.dart';
import 'package:nestify/core/widgets/wave_background.dart';
import 'package:nestify/core/widgets/animated_button.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';
import 'package:nestify/data/models/property_model.dart';
import 'package:nestify/presentation/screens/property/payment_screen.dart';
import 'package:intl/intl.dart';

class ScheduleVisitationScreen extends StatefulWidget {
  final PropertyModel property;
  final VoidCallback? onAppointmentBooked;

  const ScheduleVisitationScreen({
    Key? key,
    required this.property,
    this.onAppointmentBooked,
  }) : super(key: key);

  @override
  State<ScheduleVisitationScreen> createState() => _ScheduleVisitationScreenState();
}

class _ScheduleVisitationScreenState extends State<ScheduleVisitationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  bool _isLoading = false;

  final List<String> _timeSlots = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primaryRed,
              onPrimary: AppColors.white,
              surface: AppColors.charcoal,
              onSurface: AppColors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitVisitation() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a date'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a time slot'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate brief validation delay
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() => _isLoading = false);

    if (mounted) {
      // Navigate to payment screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(
            property: widget.property,
            visitorName: _nameController.text.trim(),
            visitorPhone: _phoneController.text.trim(),
            visitorEmail: _emailController.text.trim(),
            appointmentDate: _selectedDate!,
            appointmentTime: _selectedTimeSlot!,
            onPaymentComplete: () {
              widget.onAppointmentBooked?.call();
            },
          ),
        ),
      );
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPropertyInfo(),
                        const SizedBox(height: 24),
                        _buildDateSelection(),
                        const SizedBox(height: 24),
                        _buildTimeSlotSelection(),
                        const SizedBox(height: 24),
                        _buildVisitorInfo(),
                        const SizedBox(height: 24),
                        _buildNotesSection(),
                        const SizedBox(height: 32),
                        _buildSubmitButton(),
                        const SizedBox(height: 20),
                      ],
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
            'Book Appointment',
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

  Widget _buildDateSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Date',
          style: AppTextStyles.h5,
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.darkGray,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: _selectedDate != null
                    ? AppColors.primaryRed
                    : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: AppColors.primaryRed),
                const SizedBox(width: 12),
                Text(
                  _selectedDate != null
                      ? DateFormat('EEEE, MMMM d, y').format(_selectedDate!)
                      : 'Choose a date',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: _selectedDate != null
                        ? AppColors.white
                        : AppColors.textGray,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlotSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Time',
          style: AppTextStyles.h5,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _timeSlots.map((slot) {
            final isSelected = _selectedTimeSlot == slot;
            return GestureDetector(
              onTap: () => setState(() => _selectedTimeSlot = slot),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryRed : AppColors.darkGray,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryRed
                        : Colors.transparent,
                  ),
                ),
                child: Text(
                  slot,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isSelected ? AppColors.white : AppColors.textGray,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildVisitorInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Information',
          style: AppTextStyles.h5,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            hintText: 'Full Name',
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
            hintText: 'Email Address',
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
            hintText: 'Phone Number',
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
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Special Requests (Optional)',
          style: AppTextStyles.h5,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _notesController,
          decoration: const InputDecoration(
            hintText: 'Any special requests or questions...',
            prefixIcon: Icon(Icons.note_outlined, color: AppColors.primaryRed),
          ),
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return GradientAnimatedButton(
      text: 'Schedule Visit',
      onPressed: _submitVisitation,
      isLoading: _isLoading,
      icon: Icons.calendar_month,
      width: double.infinity,
      gradient: AppColors.primaryGradient,
    );
  }
}
