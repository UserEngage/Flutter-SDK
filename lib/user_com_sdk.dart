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
  /// Creates or gets object instance
  /// In project Use UserComSDK.instance to trigger methods
  static UserComSDK get instance => _getOrCreateInstance();

  static UserComSDK? _instance;

  static UserComSDK _getOrCreateInstance() {
    if (_instance != null) return _instance!;
    _instance = UserComSDK();
    return _instance!;
  }

  /// Create project on user.com and get your key. You can find it in settings
  /// Settings -> App settings -> Advanced -> Mobile SDK keys
  late String _mobileSdkKey;

  /// Not supported.
  String? _integrationsApiKey;

  /// Url address where user.com app is created. For example: 'https://testapp.user.com/'
  late String _appDomain;

  late Repository _repository;

  late CacheRepository _cacheRepository;

  /// Firebase Messaging token. SDK use notifications to deliver campanies form user.com
  /// You need to create Firebase project and add google-services.json files.
  String? _fcmToken;

  /// Trigger initialize method before You use any SDK methods.
  ///
  /// This function setup repositories and services.
  /// Responsible for resending failed requests and sending ping event
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

        await _registerAnonymousUserSession(fcmToken: _fcmToken);

        RequestsRetryService(_cacheRepository).resendRequests();
      },
      disconnectedOnInitialize: () async {
        await _registerAnonymousUserSession();
      },
      onConnectionRestored: () async {
        if (!NotificationService.isInitialized) {
          await NotificationService.initialize(
            onTokenReceived: (token) => _fcmToken = token,
          );
        }

        RequestsRetryService(_cacheRepository).resendRequests(
          onUserKeyChanged: () => _setupClient(),
        );
      },
    );
  }

  /// Used to notify user.com that user logs into app.
  /// It also sends basic info about device.
  Future<void> _registerAnonymousUserSession({String? fcmToken}) async {
    await _repository.postUserDeviceInfo(fcmToken: fcmToken);
    _setupClient();
  }

  /// Used to add more info to user
  ///
  /// Pass [Customer] and define your own attribues.
  /// Triggering this function will not create new user.
  /// It will override information about user created with _registerAnonymusUserSession()
  Future<void> registerUser({Customer? customer}) async {
    await _repository.postUserDeviceInfo(customer: customer);
    _setupClient();
  }

  /// Report your own event to user.com project.
  /// Event must contain [eventName] and [data]
  /// [data] can contain Map parsed to simple types.
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

  /// If project uses Navigator for app routing
  /// You can pass UserSdkNavigatorObserver inside MaterialWidget
  /// And this event will be triggered automatically
  ///
  /// If project uses different type of routing then create custom observer
  /// And trigger UserSDK.instance.sendScreenEvent('name');
  Future<void> sendScreenEvent({
    required String screenName,
  }) async {
    await _repository.sendScreenEvent(
      ScreenEvent(screenName: screenName),
    );
  }

  /// Create ProductEvent object and pass there attributes You want to collect
  /// [ProductEvent] requires productId and [ProductEventType]
  /// Pass parameters as Map. It must be parsed to simple types.
  Future<void> sendProductEvent({
    required ProductEvent event,
  }) async {
    await _repository.sendProductEvent(event);
  }

  /// Sending logout event to user.com project
  /// Deleting all cache and requests from app memory
  /// If user was registered before logout, You can post events to same user after passing user_id
  /// If user wasnt registered this function will lose all reference to user
  Future<void> logoutUser() async {
    await _repository.logoutUser();
    await _cacheRepository.clearStorage();
  }

  /// Function needs [BuildContext] to show default messages received from FCM.
  /// If [onInAppMessage] and [onNotificationMessage] is not declared
  /// App will show default messages.
  ///
  /// You can handle messages (save / display it) by declaring optional functions.
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
          if (notificationAdapter.type == NotificationType.push) {
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
