// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      userId: json['user_id'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String?,
      gender: (json['gender'] as num?)?.toInt(),
      company: json['company'] as String?,
      score: (json['score'] as num?)?.toInt(),
      assignedTo: json['assigned_to'] as String?,
      unsubscribed: json['unsubscribed'] as bool?,
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'user_id': instance.userId,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'phone_number': instance.phoneNumber,
      'gender': instance.gender,
      'company': instance.company,
      'score': instance.score,
      'assigned_to': instance.assignedTo,
      'unsubscribed': instance.unsubscribed,
    };
