import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_user_sdk/src/notifications/notification_service.dart';

extension ReceivedActionToRemoteMessage on ReceivedAction {
  RemoteMessage toRemoteMessage() {
    return RemoteMessage(
      from: NotificationService.notificationChannelKey,
      data: <String, dynamic>{
        'id': id.toString(),
        'type': '1',
        'title': title,
        'message': body,
        ...payload ?? <String, dynamic>{'link': 'None'}
      },
    );
  }
}

extension RemoteMessageToNotificationContent on RemoteMessage {
  NotificationContent toNotificationContent() {
    return NotificationContent(
      id: int.parse(data['id']),
      channelKey: NotificationService.notificationChannelKey,
      title: data['title'],
      body: data['message'],
      payload: {'link': data['link']},
    );
  }
}
