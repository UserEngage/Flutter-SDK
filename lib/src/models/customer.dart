import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

enum Gender { male, female }

@JsonSerializable()
class Customer {
  @JsonKey(name: 'user_id')
  final String? userId;
  @JsonKey(name: 'first_name')
  final String? firstName;
  @JsonKey(name: 'last_name')
  final String? lastName;
  @JsonKey(name: 'email')
  final String? email;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  @JsonKey(name: 'gender')

  /// 1 - unknown, 2 - male, 3 - female
  final int? gender;
  @JsonKey(name: 'company')
  final String? company;
  @JsonKey(name: 'score')
  final int? score;
  @JsonKey(name: 'assigned_to')
  final String? assignedTo;
  @JsonKey(name: 'unsubscribed')
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

  Map<String, dynamic> toJson() => _$CustomerToJson(this)..addAll(_attributes);

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
}
