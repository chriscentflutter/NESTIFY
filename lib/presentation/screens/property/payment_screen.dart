import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nestify/core/widgets/wave_background.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';
import 'package:nestify/data/models/property_model.dart';
import 'package:nestify/presentation/screens/property/appointment_confirmation_screen.dart';

class PaymentScreen extends StatefulWidget {
  final PropertyModel property;
  final String visitorName;
  final String visitorPhone;
  final String visitorEmail;
  final DateTime appointmentDate;
  final String appointmentTime;
  final VoidCallback onPaymentComplete;

  const PaymentScreen({
    Key? key,
    required this.property,
    required this.visitorName,
    required this.visitorPhone,
    required this.visitorEmail,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.onPaymentComplete,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with SingleTickerProviderStateMixin {
  final _cardNumberController = TextEditingController();
  final _cardNameController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _showCvv = false;
  int _selectedPaymentMethod = 0; // 0=card, 1=bank transfer
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardNameController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WaveBackground(
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
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
                          _buildOrderSummary(),
                          const SizedBox(height: 24),
                          _buildPaymentMethodSelector(),
                          const SizedBox(height: 20),
                          if (_selectedPaymentMethod == 0) ...[
                            _buildCardSection(),
                          ] else ...[
                            _buildBankTransferSection(),
                          ],
                          const SizedBox(height: 28),
                          _buildPayButton(),
                          const SizedBox(height: 16),
                          _buildSecurityNote(),
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
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.darkGray,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Secure Payment', style: AppTextStyles.h4),
                Text(
                  'Appointment booking fee',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textGray),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.success.withValues(alpha: 0.4)),
            ),
            child: const Icon(Icons.lock_outline,
                color: AppColors.success, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryRed.withValues(alpha: 0.15),
            AppColors.charcoal,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryRed.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Summary',
            style: AppTextStyles.h5.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 14),
          _summaryRow(Icons.home_work_outlined, 'Property',
              widget.property.title, null),
          const SizedBox(height: 8),
          _summaryRow(Icons.person_outline, 'Visitor',
              widget.visitorName, null),
          const SizedBox(height: 8),
          _summaryRow(Icons.calendar_today_outlined, 'Date',
              _formatDate(widget.appointmentDate), null),
          const SizedBox(height: 8),
          _summaryRow(Icons.access_time, 'Time',
              widget.appointmentTime, null),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(color: AppColors.mediumGray),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: AppTextStyles.h5.copyWith(color: AppColors.lightGray),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryRed.withValues(alpha: 0.3),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Text(
                  '₦5,000',
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(IconData icon, String label, String value, Color? color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color ?? AppColors.primaryRed),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: AppTextStyles.bodySmall
              .copyWith(color: AppColors.textGray),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              color: color ?? AppColors.lightGray,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Method', style: AppTextStyles.h5),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _payMethodTile(
                0,
                Icons.credit_card,
                'Card',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _payMethodTile(
                1,
                Icons.account_balance,
                'Bank Transfer',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _payMethodTile(int index, IconData icon, String label) {
    final selected = _selectedPaymentMethod == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryRed.withValues(alpha: 0.15)
              : AppColors.darkGray,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? AppColors.primaryRed
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected ? AppColors.primaryRed : AppColors.textGray,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: selected ? AppColors.white : AppColors.textGray,
                fontWeight:
                    selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Card Details', style: AppTextStyles.h5),
        const SizedBox(height: 14),
        // Visual card preview
        Container(
          width: double.infinity,
          height: 160,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryRed.withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('NESTIFY PAY',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.white.withValues(alpha: 0.8),
                        letterSpacing: 2,
                      )),
                  Icon(Icons.credit_card,
                      color: AppColors.white.withValues(alpha: 0.8)),
                ],
              ),
              Text(
                _cardNumberController.text.isNotEmpty
                    ? _cardNumberController.text
                    : '**** **** **** ****',
                style: AppTextStyles.h5.copyWith(
                  color: AppColors.white,
                  letterSpacing: 3,
                  fontFamily: 'monospace',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CARD HOLDER',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.white.withValues(alpha: 0.6),
                            fontSize: 9,
                          )),
                      Text(
                        _cardNameController.text.isNotEmpty
                            ? _cardNameController.text.toUpperCase()
                            : 'YOUR NAME',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('EXPIRES',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.white.withValues(alpha: 0.6),
                            fontSize: 9,
                          )),
                      Text(
                        _expiryController.text.isNotEmpty
                            ? _expiryController.text
                            : 'MM/YY',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Card Number
        TextFormField(
          controller: _cardNumberController,
          decoration: const InputDecoration(
            hintText: 'Card Number',
            prefixIcon: Icon(Icons.credit_card, color: AppColors.primaryRed),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
            _CardNumberFormatter(),
          ],
          onChanged: (_) => setState(() {}),
          validator: (v) {
            if (v == null || v.replaceAll(' ', '').length < 16) {
              return 'Enter a valid 16-digit card number';
            }
            return null;
          },
        ),
        const SizedBox(height: 14),
        // Card Name
        TextFormField(
          controller: _cardNameController,
          decoration: const InputDecoration(
            hintText: 'Name on Card',
            prefixIcon:
                Icon(Icons.person_outline, color: AppColors.primaryRed),
          ),
          textCapitalization: TextCapitalization.words,
          onChanged: (_) => setState(() {}),
          validator: (v) {
            if (v == null || v.isEmpty) return 'Enter cardholder name';
            return null;
          },
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _expiryController,
                decoration: const InputDecoration(
                  hintText: 'MM/YY',
                  prefixIcon: Icon(Icons.date_range,
                      color: AppColors.primaryRed),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                  _ExpiryFormatter(),
                ],
                onChanged: (_) => setState(() {}),
                validator: (v) {
                  if (v == null || v.length < 5) {
                    return 'Enter valid expiry';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: TextFormField(
                controller: _cvvController,
                decoration: InputDecoration(
                  hintText: 'CVV',
                  prefixIcon: const Icon(Icons.lock_outline,
                      color: AppColors.primaryRed),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showCvv ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textGray,
                    ),
                    onPressed: () => setState(() => _showCvv = !_showCvv),
                  ),
                ),
                obscureText: !_showCvv,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                validator: (v) {
                  if (v == null || v.length < 3) return 'Enter CVV';
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBankTransferSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryRed.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bank Transfer Details', style: AppTextStyles.h5),
          const SizedBox(height: 16),
          _bankRow('Bank Name', 'Nestify Payments Bank'),
          const SizedBox(height: 10),
          _bankRow('Account Number', '1234567890'),
          const SizedBox(height: 10),
          _bankRow('Account Name', 'Nestify Real Estate Ltd'),
          const SizedBox(height: 10),
          _bankRow('Amount', '₦5,000'),
          const SizedBox(height: 10),
          _bankRow('Narration',
              'Appointment - ${widget.property.id}'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: Colors.orange.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline,
                    color: Colors.orange, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'After transfer, tap "Confirm Payment" below. Booking will be confirmed instantly.',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: Colors.orange, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bankRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall
              .copyWith(color: AppColors.textGray),
        ),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPayButton() {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryRed.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handlePayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 16),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock, size: 18, color: AppColors.white),
                    const SizedBox(width: 8),
                    Text(
                      _selectedPaymentMethod == 0
                          ? 'Pay ₦5,000 Securely'
                          : 'Confirm Payment',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildSecurityNote() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shield_outlined,
              size: 14, color: AppColors.textGray),
          const SizedBox(width: 6),
          Text(
            'SSL Encrypted · 100% Secure Payment',
            style: AppTextStyles.bodySmall
                .copyWith(color: AppColors.textGray),
          ),
        ],
      ),
    );
  }

  void _handlePayment() async {
    if (_selectedPaymentMethod == 0) {
      if (!_formKey.currentState!.validate()) return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);

    // Notify parent that appointment is booked
    widget.onPaymentComplete();

    // Navigate to confirmation screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentConfirmationScreen(
          property: widget.property,
          visitorName: widget.visitorName,
          appointmentDate: widget.appointmentDate,
          appointmentTime: widget.appointmentTime,
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[d.weekday - 1]}, ${months[d.month]} ${d.day}, ${d.year}';
  }
}

// Custom input formatters
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue old, TextEditingValue updated) {
    final text = updated.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i % 4 == 0 && i != 0) buffer.write(' ');
      buffer.write(text[i]);
    }
    final str = buffer.toString();
    return updated.copyWith(
      text: str,
      selection: TextSelection.collapsed(offset: str.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue old, TextEditingValue updated) {
    final text = updated.text.replaceAll('/', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(text[i]);
    }
    final str = buffer.toString();
    return updated.copyWith(
      text: str,
      selection: TextSelection.collapsed(offset: str.length),
    );
  }
}
