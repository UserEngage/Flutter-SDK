import 'package:flutter_user_sdk/src/notifications/notification_adapter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_message.g.dart';

@JsonSerializable()
class PushNotificationMessage extends UserComMessage {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'link')
  final String link;

  PushNotificationMessage(
    this.id,
    this.title,
    this.message,
    this.link,
  );

  bool get isLinkEmpty => link == 'None';

  factory PushNotificationMessage.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationMessageFromJson(json);

  Map<String, dynamic> toJson() => _$PushNotificationMessageToJson(this);
}
