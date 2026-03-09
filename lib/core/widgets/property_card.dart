import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';

class PropertyCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String price;
  final int? bedrooms;
  final int? bathrooms;
  final double? size;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteTap;
  final String? tag; // e.g., "For Rent", "For Sale"
  
  const PropertyCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.price,
    this.bedrooms,
    this.bathrooms,
    this.size,
    this.isFavorite = false,
    required this.onTap,
    this.onFavoriteTap,
    this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.charcoal,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: double.infinity,
                      height: double.infinity,
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
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                  
                  // Tag
                  if (tag != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryRed,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          tag!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  
                  // Favorite Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onFavoriteTap ?? () {},
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.richBlack.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? AppColors.primaryRed : AppColors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Details Section
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      title,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    
                    // Location
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 12,
                          color: AppColors.textGray,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            location,
                            style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    
                    // Price
                    Text(
                      price,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primaryRed,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
