import 'package:flutter/material.dart';
import 'package:nestify/core/widgets/wave_background.dart';
import 'package:nestify/core/widgets/property_card.dart';
import 'package:nestify/core/widgets/custom_text_field.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';
import 'package:nestify/data/models/property_model.dart';
import 'package:nestify/data/services/mock_data_service.dart';

class PropertyListingScreen extends StatefulWidget {
  final String? propertyType;
  final String? priceType;
  final String? title;

  const PropertyListingScreen({
    super.key,
    this.propertyType,
    this.priceType,
    this.title,
  });

  @override
  State<PropertyListingScreen> createState() => _PropertyListingScreenState();
}

class _PropertyListingScreenState extends State<PropertyListingScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<PropertyModel> _properties = [];
  bool _isGridView = true;

  // Filter state
  String? _selectedState;
  RangeValues? _priceRange;
  double _minPrice = 0;
  double _maxPrice = 200000000;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _minPrice = MockDataService.getMinPrice();
    _maxPrice = MockDataService.getMaxPrice();
    _priceRange = RangeValues(_minPrice, _maxPrice);
    _loadProperties();
  }

  void _loadProperties() {
    setState(() {
      _properties = MockDataService.filterProperties(
        propertyType: widget.propertyType,
        priceType: widget.priceType,
        state: _selectedState,
        minPrice: _priceRange?.start,
        maxPrice: _priceRange?.end,
        searchQuery: _searchController.text,
      );
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedState = null;
      _priceRange = RangeValues(_minPrice, _maxPrice);
      _searchController.clear();
    });
    _loadProperties();
  }

  int get _activeFilterCount {
    int count = 0;
    if (_selectedState != null) count++;
    if (_priceRange != null &&
        (_priceRange!.start > _minPrice || _priceRange!.end < _maxPrice)) {
      count++;
    }
    return count;
  }

  @override
  void dispose() {
    _searchController.dispose();
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
              const SizedBox(height: 12),
              _buildSearchAndFilter(),
              // Animated filter panel
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: _showFilters ? _buildFilterPanel() : const SizedBox.shrink(),
              ),
              const SizedBox(height: 8),
              // Active filter chips
              if (_activeFilterCount > 0) _buildActiveFilters(),
              const SizedBox(height: 8),
              _buildViewToggle(),
              const SizedBox(height: 8),
              Expanded(
                child: _properties.isEmpty
                    ? _buildEmptyState()
                    : _buildPropertyList(),
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
          Container(
            decoration: const BoxDecoration(
              color: AppColors.darkGray,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: AppColors.white,
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              widget.title ?? 'All Properties',
              style: AppTextStyles.h3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SearchTextField(
        controller: _searchController,
        hint: 'Search properties...',
        onFilterTap: () {
          setState(() => _showFilters = !_showFilters);
        },
        onChanged: (_) => _loadProperties(),
      ),
    );
  }

  Widget _buildFilterPanel() {
    final states = MockDataService.getAvailableStates();

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryRed.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: AppColors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text('Filters', style: AppTextStyles.h5),
              const Spacer(),
              TextButton(
                onPressed: _resetFilters,
                child: Text(
                  'Reset',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primaryRed,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // State Filter
          Text(
            'State / Region',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.lightGray,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildStateChip('All', null),
                ...states.map((s) => _buildStateChip(s, s)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Price Range
          Row(
            children: [
              Text(
                'Price Range',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.lightGray,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '₦${_formatPriceShort(_priceRange!.start)} — ₦${_formatPriceShort(_priceRange!.end)}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primaryRed,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.primaryRed,
              inactiveTrackColor: AppColors.mediumGray,
              thumbColor: AppColors.primaryRed,
              overlayColor: AppColors.primaryRed.withValues(alpha: 0.2),
              rangeThumbShape: const RoundRangeSliderThumbShape(
                enabledThumbRadius: 8,
              ),
              trackHeight: 3,
            ),
            child: RangeSlider(
              values: _priceRange!,
              min: _minPrice,
              max: _maxPrice,
              divisions: 50,
              onChanged: (values) {
                setState(() => _priceRange = values);
              },
              onChangeEnd: (_) => _loadProperties(),
            ),
          ),
          // Min/Max labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₦${_formatPriceShort(_minPrice)}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textGray,
                  fontSize: 10,
                ),
              ),
              Text(
                '₦${_formatPriceShort(_maxPrice)}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textGray,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Apply button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _loadProperties();
                setState(() => _showFilters = false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Apply Filters',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateChip(String label, String? value) {
    final isSelected = _selectedState == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedState = value);
          _loadProperties();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.primaryGradient : null,
            color: isSelected ? null : AppColors.darkGray,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryRed
                  : AppColors.mediumGray,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: isSelected ? AppColors.white : AppColors.lightGray,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveFilters() {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          if (_selectedState != null)
            _buildFilterChip(
              '📍 $_selectedState',
              () {
                setState(() => _selectedState = null);
                _loadProperties();
              },
            ),
          if (_priceRange != null &&
              (_priceRange!.start > _minPrice || _priceRange!.end < _maxPrice))
            _buildFilterChip(
              '💰 ₦${_formatPriceShort(_priceRange!.start)} — ₦${_formatPriceShort(_priceRange!.end)}',
              () {
                setState(() => _priceRange = RangeValues(_minPrice, _maxPrice));
                _loadProperties();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryRed.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryRed.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primaryRed,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              size: 14,
              color: AppColors.primaryRed.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPriceShort(double price) {
    if (price >= 1000000000) {
      return '${(price / 1000000000).toStringAsFixed(1)}B';
    } else if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}K';
    }
    return price.toStringAsFixed(0);
  }

  Widget _buildViewToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_properties.length} Properties',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.lightGray,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.grid_view,
                  color: _isGridView ? AppColors.primaryRed : AppColors.textGray,
                ),
                onPressed: () {
                  setState(() {
                    _isGridView = true;
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.list,
                  color: !_isGridView ? AppColors.primaryRed : AppColors.textGray,
                ),
                onPressed: () {
                  setState(() {
                    _isGridView = false;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyList() {
    if (_isGridView) {
      return GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _properties.length,
        itemBuilder: (context, index) {
          return PropertyCard(
            imageUrl: _properties[index].images.first,
            title: _properties[index].title,
            location: _properties[index].location,
            price: _properties[index].formattedPrice,
            bedrooms: _properties[index].bedrooms,
            bathrooms: _properties[index].bathrooms,
            size: _properties[index].size,
            tag: _properties[index].priceType == 'rent' ? 'For Rent' : 'For Sale',
            onTap: () {
              Navigator.pushNamed(
                context,
                '/property-detail',
                arguments: _properties[index],
              );
            },
          );
        },
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _properties.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SizedBox(
              height: 280,
              child: PropertyCard(
                imageUrl: _properties[index].images.first,
                title: _properties[index].title,
                location: _properties[index].location,
                price: _properties[index].formattedPrice,
                bedrooms: _properties[index].bedrooms,
                bathrooms: _properties[index].bathrooms,
                size: _properties[index].size,
                tag: _properties[index].priceType == 'rent' ? 'For Rent' : 'For Sale',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/property-detail',
                    arguments: _properties[index],
                  );
                },
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 80,
            color: AppColors.textGray,
          ),
          const SizedBox(height: 16),
          Text(
            'No Properties Found',
            style: AppTextStyles.h4,
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.lightGray,
            ),
          ),
          if (_activeFilterCount > 0)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: TextButton.icon(
                onPressed: _resetFilters,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Reset Filters'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryRed,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
