import 'package:flutter_user_sdk/src/notifications/notification_adapter.dart';
import 'package:json_annotation/json_annotation.dart';

import '../models/events/notification_event.dart';

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
  // ignore: deprecated_member_use
  @JsonKey(ignore: true)
  final NotificationType type;

  InAppMessage(
    this.id,
    this.title,
    this.message,
    this.actionBtn,
    this.actionUrl,
  ) : type = NotificationType.inApp;

  factory InAppMessage.fromJson(Map<String, dynamic> json) =>
      _$InAppMessageFromJson(json);

  Map<String, dynamic> toJson() => _$InAppMessageToJson(this);
}
