import 'package:flutter/material.dart';
import 'package:flutter_user_sdk/data/cache_repository.dart';
import 'package:flutter_user_sdk/data/repository.dart';
import 'package:flutter_user_sdk/data/requests_retry_service.dart';
import 'package:flutter_user_sdk/data/user_api_service.dart';
import 'package:flutter_user_sdk/models/customer.dart';
import 'package:flutter_user_sdk/models/events/custom_event.dart';
import 'package:flutter_user_sdk/models/events/product_event.dart';
import 'package:flutter_user_sdk/models/events/screen_event.dart';
import 'package:flutter_user_sdk/notifications/in_app_message.dart';
import 'package:flutter_user_sdk/notifications/notification_adapter.dart';
import 'package:flutter_user_sdk/notifications/notification_builder.dart';
import 'package:flutter_user_sdk/notifications/notification_message.dart';
import 'package:flutter_user_sdk/notifications/notification_service.dart';
import 'package:flutter_user_sdk/utils/connection_service.dart';

class UserComSDK {
  static UserComSDK get instance => _getOrCreateInstance();
  static UserComSDK? _instance;

  static UserComSDK _getOrCreateInstance() {
    if (_instance != null) return _instance!;
    _instance = UserComSDK();
    return _instance!;
  }

  late String _mobileSdkKey;

  String? _integrationsApiKey;

  late String _appDomain;

  late Repository _repository;

  late CacheRepository _cacheRepository;

  String? _fcmToken;

  Future<void> initialize({
    required String mobileSdkKey,
    String? integrationsApiKey,
    required String appDomain,
  }) async {
    _mobileSdkKey = mobileSdkKey;
    _integrationsApiKey = integrationsApiKey;
    _appDomain = appDomain;

    _cacheRepository = CacheRepository();
    await _cacheRepository.initialize();

    _setupClient();

    await ConnectionService.instance.initialize(
      connectedOnInitialize: () async {
        await NotificationService.initialize(
          onTokenReceived: (token) => _fcmToken = token,
        );

        await registerAnonymousUserSession(fcmToken: _fcmToken);

        RequestsRetryService(_cacheRepository).resendRequests();
      },
      disconnectedOnInitialize: () async {
        await registerAnonymousUserSession();
      },
      onConnectionRestored: () async {
        if (!NotificationService.isInitialized) {
          await NotificationService.initialize(
            onTokenReceived: (token) => _fcmToken = token,
          );
        }
        RequestsRetryService(_cacheRepository).resendRequests();
      },
    );
  }

  Future<void> registerAnonymousUserSession({String? fcmToken}) async {
    await _repository.postUserDeviceInfo(fcmToken: fcmToken);
    _setupClient();
  }

  Future<void> registerUser({Customer? customer}) async {
    await _repository.postUserDeviceInfo(customer: customer);
    _setupClient();
  }

  Future<void> sendCustomEvent({
    required String eventName,
    required Map<String, dynamic> data,
  }) async {
    await _repository.sendCustomEvent(
      CustomEvent(
        event: eventName,
        data: data,
      ),
    );
  }

  Future<void> sendScreenEvent({
    required String screenName,
  }) async {
    await _repository.sendScreenEvent(
      ScreenEvent(screenName: screenName),
    );
  }

  Future<void> sendProductEvent({
    required ProductEvent event,
  }) async {
    await _repository.sendProductEvent(event);
  }

  Future<void> logoutUser() async {
    await _repository.logoutUser();
    await _cacheRepository.clearStorage();
  }

  void buildNotificationOnMessageReceived({
    required BuildContext context,
    Function(InAppMessage)? onInAppMessage,
    Function(PushNotificationMessage)? onNotificationMessage,
  }) {
    if (!NotificationService.messageController.hasListener) {
      NotificationService.messageController.stream.listen(
        (message) {
          if (!NotificationAdapter.isUserComMessage(message.data)) return;

          final notificationAdapter =
              NotificationAdapter.fromJson(message.data);

          if (notificationAdapter.type == NotificationType.inApp) {
            if (onInAppMessage != null) {
              onInAppMessage(message as InAppMessage);
            } else {
              NotificationBuilder.buildInAppMessage(
                context: context,
                repository: _repository,
                message: notificationAdapter.message as InAppMessage,
              );
            }
          }
          if (notificationAdapter.type == NotificationType.notification) {
            if (onNotificationMessage != null) {
              onNotificationMessage(message as PushNotificationMessage);
            } else {
              NotificationBuilder.buildPushNotification(
                context: context,
                repository: _repository,
                message: notificationAdapter.message as PushNotificationMessage,
              );
            }
          }
        },
      );
    }
  }

  void _setupClient() {
    final service = UserApiService.create(
      cacheRepository: _cacheRepository,
      mobileSdkKey: _mobileSdkKey,
      integrationsApiKey: _integrationsApiKey,
      appDomain: _appDomain,
      userKey: _cacheRepository.getUserKey(),
    );

    _repository = Repository(
      service: service,
      cacheRepository: _cacheRepository,
    );
  }
}
