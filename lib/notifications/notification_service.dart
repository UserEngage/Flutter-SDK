import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static Future<void> initialize({Function(String?)? onTokenReceived}) async {
    try {
      await Firebase.initializeApp();
      final token = await _getToken();

      if (onTokenReceived != null) {
        onTokenReceived(token);
      }
      _onMessageReceived();
    } catch (_) {
      throw Exception(
        'You have to register your app in firebase and add google-service file to project in order to use notifications and subscribe UserCom campanies',
      );
    }
  }

  static final messageController = StreamController<RemoteMessage>();

  static void _onMessageReceived() async {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      messageController.add(message);
    });

    FirebaseMessaging.onMessage.listen((message) {
      messageController.add(message);
    });

    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      messageController.add(message);
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
}
