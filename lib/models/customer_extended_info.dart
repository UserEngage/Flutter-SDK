import 'package:flutter_user_sdk/models/customer.dart';

class CustomerExtendedInfo {
  final String? userKey;

  late Map<String, dynamic> customer;

  final Map<String, dynamic> deviceInformation;

  CustomerExtendedInfo({
    this.userKey,
    Customer? customer,
    required this.deviceInformation,
  }) {
    this.customer = customer == null ? <String, dynamic>{} : customer.toJson();
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'customer': customer
        ..addAll(
          <String, dynamic>{
            'userKey': userKey ?? '',
          },
        ),
      'device': deviceInformation,
    };
  }
}
