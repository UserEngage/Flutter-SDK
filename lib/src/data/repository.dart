import 'dart:convert';

import 'package:flutter_user_sdk/src/data/cache_repository.dart';
import 'package:flutter_user_sdk/src/data/user_api_service.dart';
import 'package:flutter_user_sdk/src/models/customer.dart';
import 'package:flutter_user_sdk/src/models/customer_extended_info.dart';
import 'package:flutter_user_sdk/src/models/device_information.dart';
import 'package:flutter_user_sdk/src/models/events/custom_event.dart';
import 'package:flutter_user_sdk/src/models/events/notification_event.dart';
import 'package:flutter_user_sdk/src/models/events/logout_event.dart';
import 'package:flutter_user_sdk/src/models/events/product_event.dart';
import 'package:flutter_user_sdk/src/models/events/screen_event.dart';

class Repository {
  final UserApiService service;
  final CacheRepository cacheRepository;

  Repository({
    required this.service,
    required this.cacheRepository,
  });

  Future<void> postUserDeviceInfo({
    String? userKey,
    Customer? customer,
    String? fcmToken,
  }) async {
    try {
      final key = userKey ?? cacheRepository.getUserKey();

      final deviceInfo = await DeviceInformation.getPlatformInformation(
        fcmToken: fcmToken,
      );

      final result = await service.postPing(
        CustomerExtendedInfo(
          userKey: key,
          customer: customer,
          deviceInformation: deviceInfo,
        ),
      );

      cacheRepository.addUserKey(
        jsonDecode(result)['user']['key'] as String,
      );
    } catch (_) {}
  }

  Future<void> sendCustomEvent(CustomEvent event) async {
    try {
      await service.postEvent(event);
    } catch (_) {}
  }

  Future<void> sendScreenEvent(ScreenEvent event) async {
    try {
      await service.postScreenEvent(event);
    } catch (_) {}
  }

  Future<void> sendProductEvent(ProductEvent event) async {
    try {
      await service.postProductEvent(event);
    } catch (_) {}
  }

  Future<void> logoutUser() async {
    try {
      await service.logoutEvent(const LogoutEvent());
    } catch (_) {}
  }

  Future<void> sendNotificationEvent({
    required String id,
    required NotificationType type,
    required NotificationAction action,
  }) async {
    try {
      late NotificationEvent event;

      if (type == NotificationType.push) {
        event = NotificationEvent.push(id: id, action: action);
      } else if (type == NotificationType.inApp) {
        event = NotificationEvent.inApp(id: id, action: action);
      } else {
        throw Exception('Unsupported NotificationType');
      }

      await service.notificationEvent(id, event.type, event.action.name, event);
    } catch (_) {}
  }
}
