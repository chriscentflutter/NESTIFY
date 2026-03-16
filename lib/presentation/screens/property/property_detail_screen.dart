import 'package:flutter/material.dart' hide CarouselController;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import 'package:nestify/core/widgets/wave_background.dart';
import 'package:nestify/core/widgets/custom_button.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';
import 'package:nestify/data/models/property_model.dart';
import 'package:nestify/data/providers/favorites_provider.dart';
import 'package:nestify/presentation/screens/property/schedule_visitation_screen.dart';

import 'package:url_launcher/url_launcher.dart';

class PropertyDetailScreen extends StatefulWidget {
  final PropertyModel property;

  const PropertyDetailScreen({
    Key? key,
    required this.property,
  }) : super(key: key);

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  int _currentImageIndex = 0;
  bool _appointmentBooked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WaveBackground(
        showGradient: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageGallery(),
                  _buildPropertyInfo(),
                  _buildDescription(),
                  _buildFeatures(),
                  _buildAmenities(),
                  _buildLocation(),
                  _buildAgentInfo(),
                  const SizedBox(height: 100), // Space for bottom bar
                ],
              ),
            ),
            _buildTopBar(),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery() {
    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: widget.property.images.length,
          options: CarouselOptions(
            height: 350,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            onPageChanged: (index, reason) {
              setState(() {
                _currentImageIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            return CachedNetworkImage(
              imageUrl: widget.property.images[index],
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppColors.darkGray,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryRed,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.darkGray,
                child: const Icon(
                  Icons.image_not_supported,
                  color: AppColors.textGray,
                  size: 64,
                ),
              ),
            );
          },
        ),
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.property.images.asMap().entries.map((entry) {
              return Container(
                width: _currentImageIndex == entry.key ? 24 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _currentImageIndex == entry.key
                      ? AppColors.primaryRed
                      : AppColors.white.withValues(alpha: 0.5),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.richBlack.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: AppColors.white,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
  Consumer<FavoritesProvider>(
                builder: (context, favProv, _) {
                  final isFav = favProv.isFavorite(widget.property.id);
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.richBlack.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? AppColors.primaryRed : AppColors.white,
                      ),
                      onPressed: () async {
                        final adding = !isFav;
                        await favProv.toggleFavorite(widget.property);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              adding
                                  ? '❤️ Added to Favourites'
                                  : 'Removed from Favourites',
                            ),
                            backgroundColor: adding
                                ? AppColors.primaryRed
                                : AppColors.charcoal,
                            behavior: SnackBarBehavior.floating,
                            action: adding
                                ? SnackBarAction(
                                    label: 'View',
                                    textColor: AppColors.white,
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/favorites');
                                    },
                                  )
                                : null,
                          ),
                        );
                        if (adding && mounted) {
                          Navigator.pushNamed(context, '/favorites');
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyInfo() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.property.title,
                  style: AppTextStyles.h3,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: widget.property.priceType == 'rent'
                      ? AppColors.primaryRed
                      : AppColors.crimson,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.property.priceType == 'rent' ? 'For Rent' : 'For Sale',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on, size: 18, color: AppColors.primaryRed),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${widget.property.location}, ${widget.property.city}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.lightGray,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.property.formattedPrice,
            style: AppTextStyles.h2.copyWith(
              color: AppColors.primaryRed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: AppTextStyles.h4,
          ),
          const SizedBox(height: 12),
          Text(
            widget.property.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.lightGray,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatures() {
    final features = <Map<String, dynamic>>[];
    
    if (widget.property.bedrooms != null) {
      features.add({
        'icon': Icons.bed,
        'label': 'Bedrooms',
        'value': '${widget.property.bedrooms}',
      });
    }
    
    if (widget.property.bathrooms != null) {
      features.add({
        'icon': Icons.bathtub,
        'label': 'Bathrooms',
        'value': '${widget.property.bathrooms}',
      });
    }
    
    if (widget.property.size != null) {
      features.add({
        'icon': Icons.square_foot,
        'label': 'Size',
        'value': '${widget.property.size!.toStringAsFixed(0)} ${widget.property.sizeUnit}',
      });
    }

    if (features.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Features',
            style: AppTextStyles.h4,
          ),
          const SizedBox(height: 16),
          Row(
            children: features.map((feature) {
              return Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: AppColors.darkGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        feature['icon'] as IconData,
                        color: AppColors.primaryRed,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        feature['value'] as String,
                        style: AppTextStyles.h5,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        feature['label'] as String,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textGray,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenities() {
    if (widget.property.amenities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amenities',
            style: AppTextStyles.h4,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.property.amenities.map((amenity) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.darkGray,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.primaryRed.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: AppColors.primaryRed,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      amenity,
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLocation() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Location',
                style: AppTextStyles.h4,
              ),
              TextButton.icon(
                onPressed: () async {
                  final Uri mapsUrl = Uri.parse(
                    'https://www.google.com/maps/search/?api=1&query=${widget.property.location},${widget.property.city}',
                  );
                  if (await canLaunchUrl(mapsUrl)) {
                    await launchUrl(mapsUrl, mode: LaunchMode.externalApplication);
                  }
                },
                icon: const Icon(Icons.open_in_new, size: 16),
                label: const Text('Open in Maps'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Mock Map Widget
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.mediumGray),
              color: AppColors.darkGray,
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // Mock map grid lines
                CustomPaint(
                  size: const Size(double.infinity, 200),
                  painter: _MockMapPainter(),
                ),
                // Center pin
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.charcoal,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          widget.property.title,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.location_on,
                        color: AppColors.primaryRed,
                        size: 40,
                      ),
                    ],
                  ),
                ),
                // Zoom controls
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: Column(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.charcoal,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.add, color: AppColors.white, size: 18),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.charcoal,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.remove, color: AppColors.white, size: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 20,
                color: AppColors.primaryRed,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${widget.property.location}, ${widget.property.city}',
                  style: AppTextStyles.bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAgentInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Agent Information',
            style: AppTextStyles.h4,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.darkGray,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      widget.property.agentName[0].toUpperCase(),
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.property.agentName,
                        style: AppTextStyles.h5,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Property Agent',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.charcoal,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: _appointmentBooked
              ? _buildCallAgentButton()
              : GradientButton(
                  text: 'Book Appointment',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScheduleVisitationScreen(
                          property: widget.property,
                          onAppointmentBooked: () {
                            setState(() {
                              _appointmentBooked = true;
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildCallAgentButton() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryRed.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () async {
          final phone = widget.property.agentPhone;
          final uri = Uri(scheme: 'tel', path: phone);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        },
        icon: const Icon(Icons.phone, color: AppColors.white, size: 22),
        label: Text(
          'Call Agent — ${widget.property.agentName}',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}

class _MockMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFF3A3A3A)
      ..strokeWidth = 0.5;

    final roadPaint = Paint()
      ..color = const Color(0xFF4A4A4A)
      ..strokeWidth = 3;

    // Draw subtle grid
    for (double x = 0; x < size.width; x += 20) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw "roads"
    canvas.drawLine(
      Offset(0, size.height * 0.4),
      Offset(size.width, size.height * 0.4),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.3, 0),
      Offset(size.width * 0.3, size.height),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.7, 0),
      Offset(size.width * 0.7, size.height),
      roadPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.75),
      Offset(size.width, size.height * 0.75),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
