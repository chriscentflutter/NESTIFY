class PropertyModel {
  final String id;
  final String title;
  final String description;
  final String location;
  final String city;
  final String state;
  final double price;
  final String priceType; // 'rent' or 'sale'
  final String propertyType; // 'apartment', 'office', 'house', 'land'
  final List<String> images;
  final String? videoUrl;
  final int? bedrooms;
  final int? bathrooms;
  final double? size; // in square meters
  final String? sizeUnit;
  final bool isFeatured;
  final bool isAvailable;
  final String agentId;
  final String agentName;
  final String agentPhone;
  final String agentEmail;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> amenities;
  final double latitude;
  final double longitude;

  PropertyModel({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.city,
    required this.state,
    required this.price,
    required this.priceType,
    required this.propertyType,
    required this.images,
    this.videoUrl,
    this.bedrooms,
    this.bathrooms,
    this.size,
    this.sizeUnit = 'sqm',
    this.isFeatured = false,
    this.isAvailable = true,
    required this.agentId,
    required this.agentName,
    required this.agentPhone,
    required this.agentEmail,
    required this.createdAt,
    required this.updatedAt,
    this.amenities = const [],
    required this.latitude,
    required this.longitude,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      price: (json['price'] as num).toDouble(),
      priceType: json['priceType'] as String,
      propertyType: json['propertyType'] as String,
      images: List<String>.from(json['images'] as List),
      videoUrl: json['videoUrl'] as String?,
      bedrooms: json['bedrooms'] as int?,
      bathrooms: json['bathrooms'] as int?,
      size: json['size'] != null ? (json['size'] as num).toDouble() : null,
      sizeUnit: json['sizeUnit'] as String? ?? 'sqm',
      isFeatured: json['isFeatured'] as bool? ?? false,
      isAvailable: json['isAvailable'] as bool? ?? true,
      agentId: json['agentId'] as String,
      agentName: json['agentName'] as String,
      agentPhone: json['agentPhone'] as String,
      agentEmail: json['agentEmail'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      amenities: json['amenities'] != null
          ? List<String>.from(json['amenities'] as List)
          : [],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'city': city,
      'state': state,
      'price': price,
      'priceType': priceType,
      'propertyType': propertyType,
      'images': images,
      'videoUrl': videoUrl,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'size': size,
      'sizeUnit': sizeUnit,
      'isFeatured': isFeatured,
      'isAvailable': isAvailable,
      'agentId': agentId,
      'agentName': agentName,
      'agentPhone': agentPhone,
      'agentEmail': agentEmail,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'amenities': amenities,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  String get formattedPrice {
    if (priceType == 'rent') {
      return '₦${price.toStringAsFixed(0)}/month';
    } else {
      return '₦${price.toStringAsFixed(0)}';
    }
  }

  String get bedroomsText => bedrooms != null ? '$bedrooms bed' : '';
  String get bathroomsText => bathrooms != null ? '$bathrooms bath' : '';
  String get sizeText => size != null ? '${size!.toStringAsFixed(0)} $sizeUnit' : '';
}
