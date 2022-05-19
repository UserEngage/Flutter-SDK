// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'in_app_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InAppMessage _$InAppMessageFromJson(Map<String, dynamic> json) => InAppMessage(
      json['id'] as String,
      json['title'] as String,
      json['message'] as String,
      json['action_button_title'] as String,
      json['action_button_link'] as String?,
    );

Map<String, dynamic> _$InAppMessageToJson(InAppMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'action_button_title': instance.actionBtn,
      'action_button_link': instance.actionUrl,
    };
