// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_extended_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerExtendedInfo _$CustomerExtendedInfoFromJson(
        Map<String, dynamic> json) =>
    CustomerExtendedInfo(
      customer: Customer.fromJson(json['customer'] as Map<String, dynamic>),
      deviceInformation: json['device'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$CustomerExtendedInfoToJson(
        CustomerExtendedInfo instance) =>
    <String, dynamic>{
      'customer': instance.customer,
      'device': instance.deviceInformation,
    };
