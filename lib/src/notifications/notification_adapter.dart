import 'package:flutter_user_sdk/src/models/events/notification_event.dart';
import 'package:flutter_user_sdk/src/notifications/in_app_message.dart';
import 'package:flutter_user_sdk/src/notifications/notification_message.dart';

abstract class UserComMessage {}

class NotificationAdapter {
  final NotificationType type;
  final UserComMessage message;
  NotificationAdapter(this.type, this.message);

  factory NotificationAdapter.fromJson(Map<String, dynamic> json) {
    if (json['type'] == '4') {
      return NotificationAdapter(
        NotificationType.inApp,
        InAppMessage.fromJson(json),
      );
    } else if (json['type'] == '1') {
      return NotificationAdapter(
        NotificationType.push,
        PushNotificationMessage.fromJson(json),
      );
    } else {
      return throw Exception('This message type is not supported');
    }
  }

  static bool isUserComMessage(Map<String, dynamic> json) =>
      json.containsKey('type');
}
