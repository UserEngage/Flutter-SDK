import 'package:json_annotation/json_annotation.dart';

part 'notification_message.g.dart';

@JsonSerializable()
class NotificationMessage {
  final String id;
  final String title;
  final String message;
  final String actionBtn;
  final String? actionUrl;

  NotificationMessage(
    this.id,
    this.title,
    this.message,
    this.actionBtn,
    this.actionUrl,
  );

  factory NotificationMessage.fromJson(Map<String, dynamic> json) =>
      _$NotificationMessageFromJson(json);
}
