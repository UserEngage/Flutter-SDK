import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_user_sdk/utils/connection_service.dart';

class NotificationService {
  static bool isInitialized = false;

  static Future<void> initialize({Function(String?)? onTokenReceived}) async {
    if (!ConnectionService.instance.isConnected) return;
    try {
      await Firebase.initializeApp();

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      final token = await _getToken();

      if (onTokenReceived != null) {
        onTokenReceived(token);
      }
      _onMessageReceived();

      isInitialized = true;
    } catch (ex) {
      log('FCM not initialized properly. Try add google-services.json');
    }
  }

  static final messageController = StreamController<RemoteMessage>();

  static Future<void> _onBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    messageController.add(message);
    return Future.value(null);
  }

  static void _onMessageReceived() async {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      messageController.add(message);
    });

    FirebaseMessaging.onMessage.listen((message) {
      messageController.add(message);
    });

    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

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
