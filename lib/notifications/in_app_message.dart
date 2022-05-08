import 'package:flutter_user_sdk/notifications/notification_adapter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'in_app_message.g.dart';

@JsonSerializable()
class InAppMessage extends UserComMessage {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'action_button_title')
  final String actionBtn;
  @JsonKey(name: 'action_button_link')
  final String? actionUrl;

  InAppMessage(
    this.id,
    this.title,
    this.message,
    this.actionBtn,
    this.actionUrl,
  );

  factory InAppMessage.fromJson(Map<String, dynamic> json) =>
      _$InAppMessageFromJson(json);
}
