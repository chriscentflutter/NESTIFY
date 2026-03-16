import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nestify/core/widgets/wave_background.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';
import 'package:nestify/data/models/property_model.dart';
import 'package:nestify/data/services/mock_data_service.dart';

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

  // Image picker
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedImages = [];

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

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 80,
      );
      if (images.isNotEmpty) {
        setState(() {
          // Avoid duplicates, limit to 10 images
          for (final img in images) {
            if (_selectedImages.length < 10 &&
                !_selectedImages.any((x) => x.path == img.path)) {
              _selectedImages.add(img);
            }
          }
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open image picker: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
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
                        const SizedBox(height: 4),
                        Text(
                          '${_selectedImages.length}/10 images selected',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textGray,
                          ),
                        ),
                        const SizedBox(height: 12),
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
                  'Admin — Free listing',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Free badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green.withValues(alpha: 0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified, color: Colors.green, size: 14),
                const SizedBox(width: 4),
                Text(
                  'FREE',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
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
    return Column(
      children: [
        // Drop zone / pick button
        GestureDetector(
          onTap: _pickImages,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.charcoal,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _selectedImages.isEmpty
                    ? AppColors.mediumGray.withValues(alpha: 0.4)
                    : AppColors.primaryRed.withValues(alpha: 0.6),
                width: _selectedImages.isEmpty ? 1 : 2,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 48,
                  color: _selectedImages.isEmpty
                      ? AppColors.textGray
                      : AppColors.primaryRed,
                ),
                const SizedBox(height: 10),
                Text(
                  _selectedImages.isEmpty
                      ? 'Tap to choose images'
                      : 'Tap to add more images',
                  style: AppTextStyles.h5.copyWith(
                    color: _selectedImages.isEmpty
                        ? AppColors.textGray
                        : AppColors.primaryRed,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'JPEG, PNG · Max 10 images',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textGray,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Thumbnails
        if (_selectedImages.isNotEmpty) ...[
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) {
                final xFile = _selectedImages[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: kIsWeb
                            ? Image.network(
                                xFile.path,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(xFile.path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                      ),
                      // Remove button
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryRed,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: AppColors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                      // Index label
                      Positioned(
                        bottom: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${index + 1}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
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
                    _selectedImages.isEmpty
                        ? 'Add Property'
                        : 'Add Property (${_selectedImages.length} image${_selectedImages.length == 1 ? '' : 's'})',
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

    // Simulate API call (replace with Firestore/Supabase upload)
    await Future.delayed(const Duration(seconds: 2));

    final newProperty = PropertyModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      location: _locationController.text.trim(),
      city: 'Lagos', // Setting default for now
      state: 'Lagos', // Setting default for now
      price: double.tryParse(_priceController.text) ?? 0.0,
      priceType: _selectedPriceType,
      propertyType: _selectedPropertyType,
      images: _selectedImages.map((e) => e.path).toList(), // Local paths just for mock
      bedrooms: int.tryParse(_bedroomsController.text),
      bathrooms: int.tryParse(_bathroomsController.text),
      size: double.tryParse(_areaController.text),
      agentId: 'admin_agent',
      agentName: 'Admin User',
      agentPhone: '',
      agentEmail: 'admin@nestify.com',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      latitude: 6.5244,
      longitude: 3.3792,
    );

    MockDataService.addProperty(newProperty);

    setState(() {
      _isSubmitting = false;
    });

    if (!mounted) return;

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${_titleController.text} added successfully!${_selectedImages.isNotEmpty ? ' (${_selectedImages.length} image${_selectedImages.length == 1 ? '' : 's'})' : ''}',
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Navigate back
    Navigator.pop(context);
  }
}
