enum PropertyStatus {
  pending,
  approved,
  rejected,
}

extension PropertyStatusExtension on PropertyStatus {
  String get displayName {
    switch (this) {
      case PropertyStatus.pending:
        return 'Pending';
      case PropertyStatus.approved:
        return 'Approved';
      case PropertyStatus.rejected:
        return 'Rejected';
    }
  }

  String get color {
    switch (this) {
      case PropertyStatus.pending:
        return 'orange';
      case PropertyStatus.approved:
        return 'green';
      case PropertyStatus.rejected:
        return 'red';
    }
  }
}

class PropertySubmission {
  final String id;
  final String propertyId;
  final String agentId;
  final String agentName;
  final String agentEmail;
  final String propertyTitle;
  final String propertyType;
  final double price;
  final String priceType;
  final PropertyStatus status;
  final DateTime submittedAt;
  final String? rejectionReason;
  final DateTime? reviewedAt;
  final String? reviewedBy;

  PropertySubmission({
    required this.id,
    required this.propertyId,
    required this.agentId,
    required this.agentName,
    required this.agentEmail,
    required this.propertyTitle,
    required this.propertyType,
    required this.price,
    required this.priceType,
    required this.status,
    required this.submittedAt,
    this.rejectionReason,
    this.reviewedAt,
    this.reviewedBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyId': propertyId,
      'agentId': agentId,
      'agentName': agentName,
      'agentEmail': agentEmail,
      'propertyTitle': propertyTitle,
      'propertyType': propertyType,
      'price': price,
      'priceType': priceType,
      'status': status.name,
      'submittedAt': submittedAt.toIso8601String(),
      'rejectionReason': rejectionReason,
      'reviewedAt': reviewedAt?.toIso8601String(),
      'reviewedBy': reviewedBy,
    };
  }

  factory PropertySubmission.fromJson(Map<String, dynamic> json) {
    return PropertySubmission(
      id: json['id'] as String,
      propertyId: json['propertyId'] as String,
      agentId: json['agentId'] as String,
      agentName: json['agentName'] as String,
      agentEmail: json['agentEmail'] as String,
      propertyTitle: json['propertyTitle'] as String,
      propertyType: json['propertyType'] as String,
      price: (json['price'] as num).toDouble(),
      priceType: json['priceType'] as String,
      status: PropertyStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => PropertyStatus.pending,
      ),
      submittedAt: DateTime.parse(json['submittedAt'] as String),
      rejectionReason: json['rejectionReason'] as String?,
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.parse(json['reviewedAt'] as String)
          : null,
      reviewedBy: json['reviewedBy'] as String?,
    );
  }

  PropertySubmission copyWith({
    PropertyStatus? status,
    String? rejectionReason,
    DateTime? reviewedAt,
    String? reviewedBy,
  }) {
    return PropertySubmission(
      id: id,
      propertyId: propertyId,
      agentId: agentId,
      agentName: agentName,
      agentEmail: agentEmail,
      propertyTitle: propertyTitle,
      propertyType: propertyType,
      price: price,
      priceType: priceType,
      status: status ?? this.status,
      submittedAt: submittedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      reviewedBy: reviewedBy ?? this.reviewedBy,
    );
  }
}
