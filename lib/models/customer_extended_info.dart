import 'package:json_annotation/json_annotation.dart';

import 'package:flutter_user_sdk/models/customer.dart';

part 'customer_extended_info.g.dart';

@JsonSerializable()
class CustomerExtendedInfo {
  @JsonKey(name: 'customer')
  late Map<String, dynamic> customer;
  @JsonKey(name: 'device')
  final Map<String, dynamic> deviceInformation;

  CustomerExtendedInfo({
    required Customer customer,
    required this.deviceInformation,
  }) {
    this.customer = customer.toJson();
  }

  Map<String, dynamic> toJson() => _$CustomerExtendedInfoToJson(this);

  factory CustomerExtendedInfo.fromJson(Map<String, dynamic> json) =>
      _$CustomerExtendedInfoFromJson(json);
}
