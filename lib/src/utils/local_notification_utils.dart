import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_user_sdk/src/notifications/notification_message.dart';
import 'dart:math' as math;

const channel = AndroidNotificationChannel(
  'user_com_channel',
  'User com channel',
  description: 'User.com channel',
);

AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
  channel.id,
  channel.name,
  channelDescription: channel.description,
  icon: 'notification',
  importance: Importance.max,
  priority: Priority.max,
  fullScreenIntent: true,
  playSound: true,
);

DarwinNotificationDetails iosNotificationDetails =
    const DarwinNotificationDetails();

NotificationDetails get notificationDetails {
  if (Platform.isAndroid) {
    return NotificationDetails(android: androidNotificationDetails);
  }
  if (Platform.isIOS) {
    return NotificationDetails(iOS: iosNotificationDetails);
  }
  throw UnsupportedError(
    'Platform is not supported for User SDK sending messages',
  );
}

final initializationSettingsIOS = DarwinInitializationSettings(
  requestAlertPermission: true,
  requestBadgePermission: true,
  requestSoundPermission: true,
  onDidReceiveLocalNotification:
      (int id, String? title, String? body, String? payload) async {},
);

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {}

Future<void> initializeLocalNotifications() async {
  await requestPermission();

  await FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FlutterLocalNotificationsPlugin().initialize(
    InitializationSettings(
      android: const AndroidInitializationSettings('notification'),
      iOS: initializationSettingsIOS,
    ),
  );
}

Future<void> requestPermission() async {
  if (Platform.isAndroid) {
    await FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  } else if (Platform.isIOS) {
    await FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}

Future<void> showUserComBackgroundMessage(PushNotificationMessage data) async {
  await FlutterLocalNotificationsPlugin().show(
    math.Random().nextInt(1000),
    data.title,
    data.message,
    notificationDetails,
  );
}
