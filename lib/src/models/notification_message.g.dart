// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushNotificationMessage _$PushNotificationMessageFromJson(
        Map<String, dynamic> json) =>
    PushNotificationMessage(
      json['id'] as String,
      json['title'] as String,
      json['message'] as String,
      json['link'] as String,
    );

Map<String, dynamic> _$PushNotificationMessageToJson(
        PushNotificationMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'link': instance.link,
    };
