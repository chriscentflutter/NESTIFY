import 'package:flutter/material.dart';
import 'package:nestify/core/widgets/wave_background.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({Key? key}) : super(key: key);

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _bedroomsController = TextEditingController();
  final _bathroomsController = TextEditingController();
  final _areaController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedPropertyType = 'apartment';
  String _selectedPriceType = 'sale';
  bool _isSubmitting = false;

  final List<String> _propertyTypes = [
    'apartment',
    'house',
    'office',
    'land',
  ];

  final List<String> _priceTypes = [
    'sale',
    'rent',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    _areaController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WaveBackground(
        showGradient: false,
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
                        _buildSectionTitle('Property Details'),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _titleController,
                          label: 'Property Title',
                          hint: 'e.g., Luxury 3BR Apartment in Lekki',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter property title';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildDropdown(
                          label: 'Property Type',
                          value: _selectedPropertyType,
                          items: _propertyTypes,
                          onChanged: (value) {
                            setState(() {
                              _selectedPropertyType = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _locationController,
                          label: 'Location',
                          hint: 'e.g., Lekki Phase 1, Lagos',
                          icon: Icons.location_on,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter location';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        _buildSectionTitle('Pricing'),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildTextField(
                                controller: _priceController,
                                label: 'Price',
                                hint: '2500000',
                                keyboardType: TextInputType.number,
                                prefix: const Text('₦ '),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter price';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Invalid price';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDropdown(
                                label: 'Type',
                                value: _selectedPriceType,
                                items: _priceTypes,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedPriceType = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildSectionTitle('Property Features'),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _bedroomsController,
                                label: 'Bedrooms',
                                hint: '3',
                                keyboardType: TextInputType.number,
                                icon: Icons.bed,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTextField(
                                controller: _bathroomsController,
                                label: 'Bathrooms',
                                hint: '2',
                                keyboardType: TextInputType.number,
                                icon: Icons.bathtub,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTextField(
                                controller: _areaController,
                                label: 'Area (sqm)',
                                hint: '120',
                                keyboardType: TextInputType.number,
                                icon: Icons.square_foot,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildSectionTitle('Description'),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _descriptionController,
                          label: 'Property Description',
                          hint: 'Describe the property features, amenities, etc.',
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter description';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        _buildSectionTitle('Images'),
                        const SizedBox(height: 16),
                        _buildImageUploadSection(),
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
                  'Add New Property',
                  style: AppTextStyles.h3,
                ),
                Text(
                  'Fill in property details',
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

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: AppTextStyles.h5,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? icon,
    Widget? prefix,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon, color: AppColors.textGray) : null,
        prefix: prefix,
        filled: true,
        fillColor: AppColors.charcoal,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: AppColors.mediumGray.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: AppColors.primaryRed,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: AppColors.error,
          ),
        ),
      ),
      style: AppTextStyles.bodyMedium,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.charcoal,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: AppColors.mediumGray.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: AppColors.primaryRed,
            width: 2,
          ),
        ),
      ),
      dropdownColor: AppColors.charcoal,
      style: AppTextStyles.bodyMedium,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(
            item.toUpperCase(),
            style: AppTextStyles.bodyMedium,
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildImageUploadSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.mediumGray.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.cloud_upload,
            size: 48,
            color: AppColors.textGray,
          ),
          const SizedBox(height: 12),
          Text(
            'Upload Property Images',
            style: AppTextStyles.h5,
          ),
          const SizedBox(height: 8),
          Text(
            'Click to browse or drag and drop',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textGray,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              // TODO: Implement image picker
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Image upload feature coming soon'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.add_photo_alternate),
            label: const Text('Choose Images'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryRed,
              side: const BorderSide(color: AppColors.primaryRed),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitProperty,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Add Property',
                    style: AppTextStyles.button,
                  ),
                ],
              ),
      ),
    );
  }

  void _submitProperty() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSubmitting = false;
    });

    if (!mounted) return;

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_titleController.text} added successfully!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Navigate back
    Navigator.pop(context);
  }
}
