import 'package:flutter_user_sdk/flutter_user_sdk.dart';
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
  // ignore: deprecated_member_use
  @JsonKey(ignore: true)
  final NotificationType type;

  PushNotificationMessage(
    this.id,
    this.title,
    this.message,
    this.link,
  ) : type = NotificationType.push;

  bool get isLinkNotEmpty => link != 'None';

  factory PushNotificationMessage.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationMessageFromJson(json);

  Map<String, dynamic> toJson() => _$PushNotificationMessageToJson(this);
}
