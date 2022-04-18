class Customer {
  String id;
  String? firstName;
  String? lastName;
  String? email;
  List<Map<String, dynamic>>? attributes;

  Customer({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.attributes,
  });
}
