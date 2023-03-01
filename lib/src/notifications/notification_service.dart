import 'dart:async';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_user_sdk/src/models/events/notification_event.dart';
import 'package:flutter_user_sdk/src/notifications/notification_adapter.dart';
import 'package:flutter_user_sdk/src/notifications/notification_message.dart';
import 'package:flutter_user_sdk/src/utils/connection_service.dart';
import 'package:flutter_user_sdk/src/utils/local_notification_utils.dart';
import 'dart:math' as math;

class NotificationService {
  static const notificationChannelKey = 'user_com_channel';
  static const channelName = 'User channel';

  static bool isInitialized = false;

  static Future<void> initialize({Function(String?)? onTokenReceived}) async {
    if (!ConnectionService.instance.isConnected) return;
    try {
      await _setupFirebase();

      final token = await _getToken();

      if (onTokenReceived != null) {
        onTokenReceived(token);
      }

      await initializeLocalNotifications();

      _onMessageReceived();

      isInitialized = true;
    } catch (ex) {
      log(
        'FCM not initialized properly. Try add google-services.json. Exception: $ex',
      );
    }
  }

  static final messageController = StreamController<RemoteMessage>();

  static void _onMessageReceived() async {
    FirebaseMessaging.onMessage.listen((message) {
      messageController.add(message);
    });

    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
  }

  static Future<void> _onBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    if (NotificationAdapter.isUserComMessage(message.data)) {
      final notifiaction = NotificationAdapter.fromJson(message.data);

      if (notifiaction.type == NotificationType.push) {
        final data = notifiaction.message as PushNotificationMessage;
        await FlutterLocalNotificationsPlugin().show(
          math.Random().nextInt(100),
          data.title,
          data.message,
          notificationDetails,
        );
      }
    }
  }

  static Future<bool> _isPermssionGranted() async {
    NotificationSettings notificationSettings =
        await FirebaseMessaging.instance.getNotificationSettings();
    if (notificationSettings.authorizationStatus !=
        AuthorizationStatus.authorized) {
      notificationSettings =
          await FirebaseMessaging.instance.requestPermission();
    }
    return notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized;
  }

  static Future<String?> _getToken() async {
    final isPermissinGranted = await _isPermssionGranted();

    if (isPermissinGranted) {
      final token = await FirebaseMessaging.instance.getToken();
      return token;
    }
    return null;
  }

  static Future<void> _setupFirebase() async {
    await Firebase.initializeApp();

    await FirebaseMessaging.instance.requestPermission();

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
