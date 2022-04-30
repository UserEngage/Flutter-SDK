// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationMessage _$NotificationMessageFromJson(Map<String, dynamic> json) =>
    NotificationMessage(
      json['id'] as String,
      json['title'] as String,
      json['message'] as String,
      json['actionBtn'] as String,
      json['actionUrl'] as String?,
    );

Map<String, dynamic> _$NotificationMessageToJson(
        NotificationMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'actionBtn': instance.actionBtn,
      'actionUrl': instance.actionUrl,
    };
