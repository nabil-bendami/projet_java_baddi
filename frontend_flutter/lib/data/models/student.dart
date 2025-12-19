class Student {
  final String id;
  final String firstName;
  final String lastName;
  final String cne;
  final String email;
  final String? phone;
  final String group;
  final String? avatarUrl;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.cne,
    required this.email,
    this.phone,
    required this.group,
    this.avatarUrl,
  });

  String get fullName => '$firstName $lastName';

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      cne: json['cne'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      group: json['group'] as String,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'cne': cne,
      'email': email,
      'phone': phone,
      'group': group,
      'avatarUrl': avatarUrl,
    };
  }

  Student copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? cne,
    String? email,
    String? phone,
    String? group,
    String? avatarUrl,
  }) {
    return Student(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      cne: cne ?? this.cne,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      group: group ?? this.group,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
