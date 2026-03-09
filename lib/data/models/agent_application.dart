// Shared static store for agent applications (simulates a backend)
class AgentApplicationStore {
  static final List<AgentApplication> _applications = [];

  static List<AgentApplication> get all => List.unmodifiable(_applications);

  static void add(AgentApplication application) {
    _applications.add(application);
  }

  static void update(AgentApplication updated) {
    final index = _applications.indexWhere((a) => a.id == updated.id);
    if (index != -1) {
      _applications[index] = updated;
    }
  }
}

enum AgentApplicationStatus { pending, approved, rejected }

extension AgentApplicationStatusExtension on AgentApplicationStatus {
  String get displayName {
    switch (this) {
      case AgentApplicationStatus.pending:
        return 'Pending';
      case AgentApplicationStatus.approved:
        return 'Approved';
      case AgentApplicationStatus.rejected:
        return 'Rejected';
    }
  }
}

class AgentApplication {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String nin;
  final String? passportImagePath; // local path or null
  final AgentApplicationStatus status;
  final DateTime submittedAt;
  final DateTime? reviewedAt;
  final String? reviewedBy;
  final String? rejectionReason;

  AgentApplication({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.nin,
    this.passportImagePath,
    this.status = AgentApplicationStatus.pending,
    required this.submittedAt,
    this.reviewedAt,
    this.reviewedBy,
    this.rejectionReason,
  });

  AgentApplication copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? address,
    String? nin,
    String? passportImagePath,
    AgentApplicationStatus? status,
    DateTime? submittedAt,
    DateTime? reviewedAt,
    String? reviewedBy,
    String? rejectionReason,
  }) {
    return AgentApplication(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      nin: nin ?? this.nin,
      passportImagePath: passportImagePath ?? this.passportImagePath,
      status: status ?? this.status,
      submittedAt: submittedAt ?? this.submittedAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}
