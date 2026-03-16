import 'package:flutter/material.dart' hide CarouselController;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:nestify/core/widgets/wave_background.dart';
import 'package:nestify/core/widgets/custom_text_field.dart';
import 'package:nestify/core/widgets/custom_bottom_nav.dart';
import 'package:nestify/core/widgets/category_card.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';
import 'package:nestify/data/models/property_model.dart';
import 'package:nestify/data/services/mock_data_service.dart';
import 'package:nestify/data/providers/favorites_provider.dart';
import 'package:nestify/presentation/screens/property/property_listing_screen.dart';
import 'package:nestify/presentation/screens/favorites/favorites_screen.dart';
import 'package:nestify/presentation/screens/profile/profile_screen.dart';
import 'package:nestify/presentation/screens/settings/help_support_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  List<PropertyModel> _featuredProperties = [];
  int _currentCarouselIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadFeaturedProperties();
  }

  void _loadFeaturedProperties() {
    setState(() {
      _featuredProperties = MockDataService.getFeaturedProperties();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getSelectedScreen(),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        onCenterTap: () {
          // Navigate to favorites
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FavoritesScreen(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),
          const SizedBox(height: 20),
          
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SearchTextField(
              controller: _searchController,
              hint: 'Search properties...',
              onFilterTap: () {
                // TODO: Show filter dialog
              },
            ),
          ),
          const SizedBox(height: 24),
          
          // Categories
          _buildCategories(),
          const SizedBox(height: 24),
          
          // Featured Properties Carousel
          _buildFeaturedSection(),
          const SizedBox(height: 24),
          
          // Quick Actions
          _buildQuickActions(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Avatar with gradient border
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
            ),
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.charcoal,
              ),
              child: Center(
                child: Text(
                  'JD',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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
                  'Welcome Back! 👋',
                  style: AppTextStyles.h3,
                ),
                const SizedBox(height: 4),
                Text(
                  'Find your perfect property',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.lightGray,
                  ),
                ),
              ],
            ),
          ),
          // Notification button with badge
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryRed.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  color: AppColors.white,
                  onPressed: () {
                    Navigator.pushNamed(context, '/notifications');
                  },
                ),
              ),
              // Notification badge
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.darkGray,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    final categories = [
      {
        'icon': Icons.apartment_rounded,
        'label': 'Apartments',
        'type': 'apartment',
        'gradient': LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE53935), Color(0xFFD32F2F)],
        ),
        'emoji': '🏢',
      },
      {
        'icon': Icons.business_rounded,
        'label': 'Offices',
        'type': 'office',
        'gradient': LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF4511E), Color(0xFFE64A19)],
        ),
        'emoji': '💼',
      },
      {
        'icon': Icons.home_rounded,
        'label': 'Houses',
        'type': 'house',
        'gradient': LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFD32F2F), Color(0xFFC62828)],
        ),
        'emoji': '🏠',
      },
      {
        'icon': Icons.landscape_rounded,
        'label': 'Land',
        'type': 'land',
        'gradient': LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFC62828), Color(0xFFB71C1C)],
        ),
        'emoji': '🌳',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.category_rounded,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Categories',
                style: AppTextStyles.h4,
              ),
              const Spacer(),
              Text(
                'Explore All',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primaryRed,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: AppColors.primaryRed,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final category = categories[index];
              return _buildCategoryCard(
                icon: category['icon'] as IconData,
                label: category['label'] as String,
                type: category['type'] as String,
                gradient: category['gradient'] as LinearGradient,
                emoji: category['emoji'] as String,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard({
    required IconData icon,
    required String label,
    required String type,
    required LinearGradient gradient,
    required String emoji,
  }) {
    return CategoryCard(
      icon: icon,
      label: label,
      gradient: gradient,
      emoji: emoji,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyListingScreen(
              propertyType: type,
              title: label,
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeaturedSection() {
    if (_featuredProperties.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Properties',
                style: AppTextStyles.h4,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PropertyListingScreen(
                        title: 'All Properties',
                      ),
                    ),
                  );
                },
                child: Text(
                  'See All',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryRed,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        CarouselSlider.builder(
          itemCount: _featuredProperties.length,
          options: CarouselOptions(
            height: 280,
            viewportFraction: 0.85,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            onPageChanged: (index, reason) {
              setState(() {
                _currentCarouselIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            return _buildFeaturedPropertyCard(_featuredProperties[index]);
          },
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _featuredProperties.asMap().entries.map((entry) {
            return Container(
              width: _currentCarouselIndex == entry.key ? 24 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _currentCarouselIndex == entry.key
                    ? AppColors.primaryRed
                    : AppColors.mediumGray,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFeaturedPropertyCard(PropertyModel property) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/property-detail',
          arguments: property,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.charcoal,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: CachedNetworkImage(
                      imageUrl: property.images.first,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 150,
                        color: AppColors.darkGray,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryRed,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 150,
                        color: AppColors.darkGray,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: AppColors.textGray,
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'FEATURED',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Consumer<FavoritesProvider>(
                      builder: (context, favProv, _) {
                        final isFav = favProv.isFavorite(property.id);
                        return GestureDetector(
                          onTap: () async {
                            final adding = !isFav;
                            await favProv.toggleFavorite(property);
                            if (!context.mounted) return;
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
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.richBlack.withValues(alpha: 0.6),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? AppColors.primaryRed : AppColors.white,
                              size: 20,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                ],
              ),
              
              // Details
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      property.title,
                      style: AppTextStyles.h5,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 13, color: AppColors.textGray),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            property.location,
                            style: AppTextStyles.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (property.bedrooms != null || property.bathrooms != null)
                          Row(
                            children: [
                              if (property.bedrooms != null) ...[
                                const Icon(Icons.bed, size: 13, color: AppColors.textGray),
                                const SizedBox(width: 4),
                                Text(property.bedroomsText, style: AppTextStyles.bodySmall),
                                const SizedBox(width: 10),
                              ],
                              if (property.bathrooms != null) ...[
                                const Icon(Icons.bathtub, size: 13, color: AppColors.textGray),
                                const SizedBox(width: 4),
                                Text(property.bathroomsText, style: AppTextStyles.bodySmall),
                              ],
                            ],
                          ),
                        Text(
                          property.formattedPrice,
                          style: AppTextStyles.priceSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: AppTextStyles.h4,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.shopping_cart,
                  label: 'Buy Property',
                  color: AppColors.primaryRed,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PropertyListingScreen(
                          priceType: 'sale',
                          title: 'Buy Property',
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.key,
                  label: 'Rent Property',
                  color: AppColors.crimson,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PropertyListingScreen(
                          priceType: 'rent',
                          title: 'Rent Property',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: AppColors.white),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
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

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        // Home Screen
        return WaveBackground(
          showGradient: false,
          child: SafeArea(
            child: _buildHomeContent(),
          ),
        );
      case 1:
        // Search/Property Listing Screen
        return const PropertyListingScreen();
      case 2:
        // Support/Help Screen
        return const HelpSupportScreen();
      case 3:
        // Profile Screen
        return const ProfileScreen();
      default:
        return WaveBackground(
          showGradient: false,
          child: SafeArea(
            child: _buildHomeContent(),
          ),
        );
    }
  }
}
