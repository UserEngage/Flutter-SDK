import 'package:flutter_user_sdk/src/models/dto_to_model.dart';
import 'package:flutter_user_sdk/src/models/events/notification_event.dart';
import 'package:flutter_user_sdk/src/models/in_app_message_dto.dart';
import 'package:flutter_user_sdk/src/models/notification_message.dart';

abstract class UserComMessage {}

class NotificationAdapter {
  final NotificationType type;
  final UserComMessage message;
  NotificationAdapter(this.type, this.message);

  factory NotificationAdapter.fromJson(Map<String, dynamic> json) {
    final messageType = json['type'];
    if (messageType == NotificationType.inApp.value) {
      final inAppDto = InAppMessageDto.fromJson(json['inapp_message']);

      return NotificationAdapter(
        NotificationType.inApp,
        inAppMessageDtoToModel(json['id'], inAppDto),
      );
    } else if (messageType == NotificationType.push.value) {
      return NotificationAdapter(
        NotificationType.push,
        PushNotificationMessage.fromJson(json),
      );
    } else {
      return throw Exception(
        'This message type is not supported by User.com SDK',
      );
    }
  }

  static bool isUserComMessage(Map<String, dynamic> json) =>
      json.containsKey('type');
}
