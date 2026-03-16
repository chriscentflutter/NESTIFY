import '../models/property_model.dart';

class MockDataService {
  static final List<PropertyModel> _properties = [
      // Featured Properties
      PropertyModel(
        id: '1',
        title: '3 Bedroom Luxury Apartment',
        description: 'Beautiful modern apartment in the heart of Lekki Phase 1. Features include spacious living room, modern kitchen, en-suite bathrooms, and 24/7 security.',
        location: 'Lekki Phase 1',
        city: 'Lagos',
        state: 'Lagos',
        price: 2500000,
        priceType: 'rent',
        propertyType: 'apartment',
        images: [
          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
          'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
        ],
        bedrooms: 3,
        bathrooms: 3,
        size: 120,
        isFeatured: true,
        agentId: 'agent1',
        agentName: 'Adebayo Johnson',
        agentPhone: '+234 801 234 5678',
        agentEmail: 'adebayo@nestify.com',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        amenities: ['Swimming Pool', 'Gym', 'Parking', 'Security', 'Generator'],
        latitude: 6.4474,
        longitude: 3.4700,
      ),
      PropertyModel(
        id: '2',
        title: 'Modern Office Space',
        description: 'Prime office space in Victoria Island perfect for startups and small businesses. Fully furnished with high-speed internet and backup power.',
        location: 'Victoria Island',
        city: 'Lagos',
        state: 'Lagos',
        price: 1800000,
        priceType: 'rent',
        propertyType: 'office',
        images: [
          'https://images.unsplash.com/photo-1497366216548-37526070297c?w=800',
          'https://images.unsplash.com/photo-1497366811353-6870744d04b2?w=800',
        ],
        size: 85,
        isFeatured: true,
        agentId: 'agent2',
        agentName: 'Chioma Okafor',
        agentPhone: '+234 802 345 6789',
        agentEmail: 'chioma@nestify.com',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
        amenities: ['WiFi', 'Parking', 'Conference Room', 'Air Conditioning'],
        latitude: 6.4281,
        longitude: 3.4219,
      ),
      PropertyModel(
        id: '3',
        title: '5 Bedroom Detached Duplex',
        description: 'Spacious family home in a serene estate. Features include BQ, ample parking, beautiful garden, and modern fittings.',
        location: 'Magodo GRA',
        city: 'Lagos',
        state: 'Lagos',
        price: 85000000,
        priceType: 'sale',
        propertyType: 'house',
        images: [
          'https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=800',
          'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800',
          'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=800',
        ],
        bedrooms: 5,
        bathrooms: 5,
        size: 350,
        isFeatured: true,
        agentId: 'agent1',
        agentName: 'Adebayo Johnson',
        agentPhone: '+234 801 234 5678',
        agentEmail: 'adebayo@nestify.com',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        amenities: ['BQ', 'Garden', 'Parking', 'Security', 'Generator', 'Water'],
        latitude: 6.5833,
        longitude: 3.3833,
      ),
      PropertyModel(
        id: '4',
        title: '600sqm Land in Ikoyi',
        description: 'Prime land for sale in Ikoyi. Perfect for residential or commercial development. C of O available.',
        location: 'Ikoyi',
        city: 'Lagos',
        state: 'Lagos',
        price: 120000000,
        priceType: 'sale',
        propertyType: 'land',
        images: [
          'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800',
        ],
        size: 600,
        isFeatured: true,
        agentId: 'agent3',
        agentName: 'Emeka Nwosu',
        agentPhone: '+234 803 456 7890',
        agentEmail: 'emeka@nestify.com',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
        amenities: ['C of O', 'Fenced', 'Gated Estate'],
        latitude: 6.4550,
        longitude: 3.4200,
      ),
      
      // Regular Properties
      PropertyModel(
        id: '5',
        title: '2 Bedroom Flat',
        description: 'Affordable 2 bedroom apartment in a quiet neighborhood. Good for small families.',
        location: 'Surulere',
        city: 'Lagos',
        state: 'Lagos',
        price: 1200000,
        priceType: 'rent',
        propertyType: 'apartment',
        images: [
          'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=800',
        ],
        bedrooms: 2,
        bathrooms: 2,
        size: 75,
        agentId: 'agent2',
        agentName: 'Chioma Okafor',
        agentPhone: '+234 802 345 6789',
        agentEmail: 'chioma@nestify.com',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        amenities: ['Parking', 'Security'],
        latitude: 6.4969,
        longitude: 3.3561,
      ),
      PropertyModel(
        id: '6',
        title: 'Co-working Space',
        description: 'Flexible co-working space with hot desks and private offices available.',
        location: 'Yaba',
        city: 'Lagos',
        state: 'Lagos',
        price: 50000,
        priceType: 'rent',
        propertyType: 'office',
        images: [
          'https://images.unsplash.com/photo-1497366754035-f200968a6e72?w=800',
        ],
        size: 200,
        agentId: 'agent3',
        agentName: 'Emeka Nwosu',
        agentPhone: '+234 803 456 7890',
        agentEmail: 'emeka@nestify.com',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now(),
        amenities: ['WiFi', 'Coffee', 'Meeting Rooms', 'Printing'],
        latitude: 6.5074,
        longitude: 3.3719,
      ),
      PropertyModel(
        id: '7',
        title: '4 Bedroom Terrace',
        description: 'Beautiful terrace house in a gated estate with excellent facilities.',
        location: 'Ajah',
        city: 'Lagos',
        state: 'Lagos',
        price: 45000000,
        priceType: 'sale',
        propertyType: 'house',
        images: [
          'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=800',
        ],
        bedrooms: 4,
        bathrooms: 4,
        size: 200,
        agentId: 'agent1',
        agentName: 'Adebayo Johnson',
        agentPhone: '+234 801 234 5678',
        agentEmail: 'adebayo@nestify.com',
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        amenities: ['Swimming Pool', 'Gym', 'Playground', 'Security'],
        latitude: 6.4698,
        longitude: 3.5852,
      ),
      PropertyModel(
        id: '8',
        title: '1000sqm Commercial Land',
        description: 'Strategic commercial land along Lekki-Epe Expressway.',
        location: 'Lekki-Epe Expressway',
        city: 'Lagos',
        state: 'Lagos',
        price: 95000000,
        priceType: 'sale',
        propertyType: 'land',
        images: [
          'https://images.unsplash.com/photo-1464146072230-91cabc968266?w=800',
        ],
        size: 1000,
        agentId: 'agent2',
        agentName: 'Chioma Okafor',
        agentPhone: '+234 802 345 6789',
        agentEmail: 'chioma@nestify.com',
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        updatedAt: DateTime.now().subtract(const Duration(days: 4)),
        amenities: ['C of O', 'Road Access'],
        latitude: 6.4333,
        longitude: 3.5500,
      ),

      // Properties in other Nigerian states
      PropertyModel(
        id: '9',
        title: '4 Bedroom Semi-Detached Duplex',
        description: 'Luxury duplex in Asokoro with premium finishes, spacious compound, and modern amenities.',
        location: 'Asokoro',
        city: 'Abuja',
        state: 'Abuja (FCT)',
        price: 75000000,
        priceType: 'sale',
        propertyType: 'house',
        images: [
          'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800',
        ],
        bedrooms: 4,
        bathrooms: 4,
        size: 280,
        isFeatured: true,
        agentId: 'agent4',
        agentName: 'Fatima Bello',
        agentPhone: '+234 805 678 9012',
        agentEmail: 'fatima@nestify.com',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        amenities: ['BQ', 'Garden', 'Security', 'Generator', 'Parking'],
        latitude: 9.0579,
        longitude: 7.4951,
      ),
      PropertyModel(
        id: '10',
        title: '3 Bedroom Flat in Maitama',
        description: 'Modern apartment in the upscale Maitama district, close to the city center.',
        location: 'Maitama',
        city: 'Abuja',
        state: 'Abuja (FCT)',
        price: 3500000,
        priceType: 'rent',
        propertyType: 'apartment',
        images: [
          'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800',
        ],
        bedrooms: 3,
        bathrooms: 3,
        size: 140,
        agentId: 'agent4',
        agentName: 'Fatima Bello',
        agentPhone: '+234 805 678 9012',
        agentEmail: 'fatima@nestify.com',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        amenities: ['Parking', 'Security', 'Water', 'Elevator'],
        latitude: 9.0765,
        longitude: 7.4898,
      ),
      PropertyModel(
        id: '11',
        title: 'Luxury Waterfront Villa',
        description: 'Stunning waterfront property in Port Harcourt with panoramic views and private dock.',
        location: 'Old GRA',
        city: 'Port Harcourt',
        state: 'Rivers',
        price: 110000000,
        priceType: 'sale',
        propertyType: 'house',
        images: [
          'https://images.unsplash.com/photo-1613977257363-707ba9348227?w=800',
        ],
        bedrooms: 5,
        bathrooms: 6,
        size: 400,
        agentId: 'agent5',
        agentName: 'Blessing Orji',
        agentPhone: '+234 806 789 0123',
        agentEmail: 'blessing@nestify.com',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        amenities: ['Swimming Pool', 'Private Dock', 'Garden', 'Security', 'Generator'],
        latitude: 4.7748,
        longitude: 7.0068,
      ),
      PropertyModel(
        id: '12',
        title: '2 Bedroom Apartment',
        description: 'Affordable modern apartment in the University of Ibadan area, ideal for professionals.',
        location: 'Bodija',
        city: 'Ibadan',
        state: 'Oyo',
        price: 600000,
        priceType: 'rent',
        propertyType: 'apartment',
        images: [
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
        ],
        bedrooms: 2,
        bathrooms: 2,
        size: 80,
        agentId: 'agent5',
        agentName: 'Blessing Orji',
        agentPhone: '+234 806 789 0123',
        agentEmail: 'blessing@nestify.com',
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
        amenities: ['Parking', 'Security'],
        latitude: 7.4014,
        longitude: 3.9206,
      ),
      PropertyModel(
        id: '13',
        title: '500sqm Residential Plot',
        description: 'Well-located residential land in New Haven, Enugu. Ideal for family home development.',
        location: 'New Haven',
        city: 'Enugu',
        state: 'Enugu',
        price: 15000000,
        priceType: 'sale',
        propertyType: 'land',
        images: [
          'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800',
        ],
        size: 500,
        agentId: 'agent4',
        agentName: 'Fatima Bello',
        agentPhone: '+234 805 678 9012',
        agentEmail: 'fatima@nestify.com',
        createdAt: DateTime.now().subtract(const Duration(days: 9)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
        amenities: ['Fenced', 'Gazette'],
        latitude: 6.4584,
        longitude: 7.5464,
      ),
      PropertyModel(
        id: '14',
        title: 'Office Space in Wuse',
        description: 'Premium office space in Wuse II, fully serviced with backup power and internet.',
        location: 'Wuse II',
        city: 'Abuja',
        state: 'Abuja (FCT)',
        price: 2000000,
        priceType: 'rent',
        propertyType: 'office',
        images: [
          'https://images.unsplash.com/photo-1497366754035-f200968a6e72?w=800',
        ],
        size: 120,
        agentId: 'agent4',
        agentName: 'Fatima Bello',
        agentPhone: '+234 805 678 9012',
        agentEmail: 'fatima@nestify.com',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now(),
        amenities: ['WiFi', 'Generator', 'Parking', 'Air Conditioning', 'Security'],
        latitude: 9.0643,
        longitude: 7.4709,
      ),
    ];

  static List<PropertyModel> getMockProperties() {
    return _properties;
  }

  static void addProperty(PropertyModel property) {
    _properties.insert(0, property);
  }

  static List<PropertyModel> getFeaturedProperties() {
    return getMockProperties().where((p) => p.isFeatured).toList();
  }

  static List<PropertyModel> getPropertiesByType(String type) {
    return getMockProperties().where((p) => p.propertyType == type).toList();
  }

  static List<PropertyModel> getPropertiesByPriceType(String priceType) {
    return getMockProperties().where((p) => p.priceType == priceType).toList();
  }

  static List<PropertyModel> getPropertiesByState(String state) {
    return getMockProperties().where((p) => p.state == state).toList();
  }

  static List<String> getAvailableStates() {
    return getMockProperties().map((p) => p.state).toSet().toList()..sort();
  }

  static double getMinPrice() {
    final prices = getMockProperties().map((p) => p.price).toList();
    prices.sort();
    return prices.first;
  }

  static double getMaxPrice() {
    final prices = getMockProperties().map((p) => p.price).toList();
    prices.sort();
    return prices.last;
  }

  static List<PropertyModel> filterProperties({
    String? propertyType,
    String? priceType,
    String? state,
    double? minPrice,
    double? maxPrice,
    String? searchQuery,
  }) {
    var properties = getMockProperties();
    
    if (propertyType != null) {
      properties = properties.where((p) => p.propertyType == propertyType).toList();
    }
    if (priceType != null) {
      properties = properties.where((p) => p.priceType == priceType).toList();
    }
    if (state != null) {
      properties = properties.where((p) => p.state == state).toList();
    }
    if (minPrice != null) {
      properties = properties.where((p) => p.price >= minPrice).toList();
    }
    if (maxPrice != null) {
      properties = properties.where((p) => p.price <= maxPrice).toList();
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      properties = properties.where((p) =>
        p.title.toLowerCase().contains(query) ||
        p.location.toLowerCase().contains(query) ||
        p.city.toLowerCase().contains(query) ||
        p.state.toLowerCase().contains(query)
      ).toList();
    }
    
    return properties;
  }

  static PropertyModel? getPropertyById(String id) {
    try {
      return getMockProperties().firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}
