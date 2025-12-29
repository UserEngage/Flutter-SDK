enum Gender { male, female }

class Customer {
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;

  /// 1 - unknown, 2 - male, 3 - female
  final int? gender;
  final String? company;
  final int? score;
  final String? assignedTo;
  final bool? unsubscribed;

  Customer({
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.gender,
    this.company,
    this.score,
    this.assignedTo,
    this.unsubscribed,
  });

  final _attributes = <String, dynamic>{};

  void addCustomAttribute(String name, dynamic value) {
    assert(
      value is String || value is bool || value is int,
      'Value must be primary type - string, bool or int',
    );
    _attributes.addAll(<String, dynamic>{name: value});
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (userId != null) map['user_id'] = userId;
    if (firstName != null) map['first_name'] = firstName;
    if (lastName != null) map['last_name'] = lastName;
    if (email != null) map['email'] = email;
    if (phoneNumber != null) map['phone_number'] = phoneNumber;
    if (gender != null) map['gender'] = gender;
    if (company != null) map['company'] = company;
    if (score != null) map['score'] = score;
    if (assignedTo != null) map['assigned_to'] = assignedTo;
    if (unsubscribed != null) map['unsubscribed'] = unsubscribed;
    map.addAll(_attributes);
    return map;
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      userId: json['user_id'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String?,
      gender: json['gender'] as int?,
      company: json['company'] as String?,
      score: json['score'] as int?,
      assignedTo: json['assigned_to'] as String?,
      unsubscribed: json['unsubscribed'] as bool?,
    );
  }
}
