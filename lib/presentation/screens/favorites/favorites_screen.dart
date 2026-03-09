import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nestify/core/widgets/wave_background.dart';
import 'package:nestify/core/widgets/property_card.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';
import 'package:nestify/data/providers/favorites_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WaveBackground(
        showGradient: false,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Favorites',
                          style: AppTextStyles.h3,
                        ),
                        const SizedBox(height: 4),
                        Consumer<FavoritesProvider>(
                          builder: (context, favoritesProvider, _) {
                            return Text(
                              '${favoritesProvider.favoritesCount} ${favoritesProvider.favoritesCount == 1 ? "property" : "properties"}',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textGray,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Consumer<FavoritesProvider>(
                      builder: (context, favoritesProvider, _) {
                        if (favoritesProvider.favoritesCount == 0) {
                          return const SizedBox.shrink();
                        }
                        return TextButton.icon(
                          onPressed: () {
                            _showClearConfirmation(context);
                          },
                          icon: const Icon(Icons.delete_outline, size: 20),
                          label: const Text('Clear All'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.error,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Favorites List
              Expanded(
                child: Consumer<FavoritesProvider>(
                  builder: (context, favoritesProvider, _) {
                    if (favoritesProvider.favoritesCount == 0) {
                      return _buildEmptyState(context);
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: favoritesProvider.favoritesCount,
                      itemBuilder: (context, index) {
                        final property = favoritesProvider.favorites[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: PropertyCard(
                            imageUrl: property.images.first,
                            title: property.title,
                            location: property.location,
                            price: property.formattedPrice,
                            bedrooms: property.bedrooms,
                            bathrooms: property.bathrooms,
                            size: property.size,
                            isFavorite: true,
                            tag: property.priceType == 'rent' ? 'For Rent' : 'For Sale',
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/property-detail',
                                arguments: property,
                              );
                            },
                            onFavoriteTap: () {
                              favoritesProvider.removeFavorite(property.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Removed from favorites'),
                                  backgroundColor: AppColors.charcoal,
                                  behavior: SnackBarBehavior.floating,
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    textColor: AppColors.primaryRed,
                                    onPressed: () {
                                      favoritesProvider.addFavorite(property);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.darkGray,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border,
              size: 60,
              color: AppColors.textGray,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Favorites Yet',
            style: AppTextStyles.h4,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Start adding properties to your favorites to see them here',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textGray,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/property-listing');
            },
            icon: const Icon(Icons.search),
            label: const Text('Browse Properties'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.charcoal,
        title: Text('Clear All Favorites?', style: AppTextStyles.h5),
        content: Text(
          'This will remove all properties from your favorites list.',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.lightGray),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<FavoritesProvider>().clearFavorites();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All favorites cleared'),
                  backgroundColor: AppColors.charcoal,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
