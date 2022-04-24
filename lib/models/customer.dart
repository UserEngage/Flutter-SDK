import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer {
  @JsonKey(name: 'user_id')
  String? userId;
  @JsonKey(name: 'userKey')
  String? userKey;
  @JsonKey(name: 'first_name')
  String? firstName;
  @JsonKey(name: 'last_name')
  String? lastName;
  @JsonKey(name: 'email')
  String? email;

  Customer({
    this.userId,
    this.userKey,
    this.firstName,
    this.lastName,
    this.email,
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
