class ContactModel {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final DateTime createdAt;

  ContactModel({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Create copy with updated fields
  ContactModel copyWith({
    String? id,
    String? name,
    String? email,
    String? mobile,
    DateTime? createdAt,
  }) {
    return ContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'ContactModel(id: $id, name: $name, email: $email, mobile: $mobile)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ContactModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
