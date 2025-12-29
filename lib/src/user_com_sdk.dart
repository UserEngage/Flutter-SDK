import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_user_sdk/src/data/cache_repository.dart';
import 'package:flutter_user_sdk/src/data/repository.dart';
import 'package:flutter_user_sdk/src/data/requests_retry_service.dart';
import 'package:flutter_user_sdk/src/data/user_api_service.dart';
import 'package:flutter_user_sdk/src/models/customer.dart';
import 'package:flutter_user_sdk/src/models/events/custom_event.dart';
import 'package:flutter_user_sdk/src/models/events/notification_event.dart';
import 'package:flutter_user_sdk/src/models/events/product_event.dart';
import 'package:flutter_user_sdk/src/models/events/screen_event.dart';
import 'package:flutter_user_sdk/src/models/in_app_message_model.dart';
import 'package:flutter_user_sdk/src/models/notification_message.dart';
import 'package:flutter_user_sdk/src/notifications/notification_adapter.dart';
import 'package:flutter_user_sdk/src/notifications/notification_builder.dart';
import 'package:flutter_user_sdk/src/utils/connection_service.dart';

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

  late bool _enableLogging;

  /// Create project on user.com and get your key. You can find it in settings
  /// Settings -> App settings -> Advanced -> Mobile SDK keys
  late String _mobileSdkKey;

  /// Not supported.
  String? _integrationsApiKey;

  /// Url address where user.com app is created. For example: 'https://testapp.user.com/'
  late String _baseUrl;

  late Repository _repository;

  late CacheRepository _cacheRepository;

  /// Firebase Messaging token. SDK use notifications to deliver campanies form user.com
  /// You need to create Firebase project and add google-services.json files.
  String? _fcmToken;

  static const _notificationChannelKey = 'user_com_channel';

  /// Trigger initialize method before You use any SDK methods.
  ///
  /// This function setup repositories and services.
  /// Responsible for resending failed requests and sending ping event
  Future<void> initialize({
    required String mobileSdkKey,
    String? integrationsApiKey,
    required String baseUrl,
    String? fcmToken,
    bool enableLogging = true,
  }) async {
    _mobileSdkKey = mobileSdkKey;
    _integrationsApiKey = integrationsApiKey;
    _baseUrl = baseUrl;
    _enableLogging = enableLogging;
    _fcmToken = fcmToken;

    _cacheRepository = CacheRepository();
    await _cacheRepository.initialize();

    _setupClient();

    await ConnectionService.instance.initialize(
      connectedOnInitialize: () async {
        await _registerAnonymousUserSession(fcmToken: _fcmToken);

        RequestsRetryService(_cacheRepository).resendRequests();
      },
      disconnectedOnInitialize: () async {
        await _registerAnonymousUserSession();
      },
      onConnectionRestored: () async {
        RequestsRetryService(
          _cacheRepository,
        ).resendRequests(onUserKeyChanged: () => _setupClient());
      },
    );
  }

  Future<void> setFcmToken(String token) async {
    await _registerAnonymousUserSession(fcmToken: _fcmToken);
    _fcmToken = token;
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
  /// Triggering this function will change user status from visitor to user.
  /// It will override information about user created with _registerAnonymusUserSession()
  Future<void> registerUser({Customer? customer}) async {
    await _repository.postUserDeviceInfo(
      customer: customer,
      fcmToken: _fcmToken,
    );
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
      CustomEvent(event: eventName, data: data),
    );
  }

  /// If project uses Navigator for app routing
  /// You can pass UserSdkNavigatorObserver inside MaterialWidget
  /// And this event will be triggered automatically
  ///
  /// If project uses different type of routing then create custom observer
  /// And trigger UserSDK.instance.sendScreenEvent('name');
  Future<void> sendScreenEvent({required String screenName}) async {
    await _repository.sendScreenEvent(ScreenEvent(screenName: screenName));
  }

  /// Create ProductEvent object and pass there attributes You want to collect
  /// [ProductEvent] requires productId and [ProductEventType]
  /// Pass parameters as Map. It must be parsed to simple types.
  Future<void> sendProductEvent({required ProductEvent event}) async {
    await _repository.sendProductEvent(event);
  }

  /// Sending logout event to user.com project
  /// Deleting all cache and requests from app memory
  /// If user was registered before logout, You can post events to same user after passing user_id
  /// If user wasnt registered this function will lose all reference to user
  Future<void> logoutUser() async {
    await _repository.logoutUser();
    await _cacheRepository.clearStorage();
    log(
      'Logout successful. Creating new anonymous session to track user activity',
    );
    await _registerAnonymousUserSession(fcmToken: _fcmToken);
  }

  /// Use this method to notify User.com service that notification was opened
  /// Trigger this only when You specify [onInAppMessage] and [onNotificationMessage]
  /// inside [buildNotification] function
  Future<void> notificationClickedEvent({
    required String id,
    required NotificationType type,
  }) async {
    await _repository.sendNotificationEvent(
      id: id,
      type: type,
      action: NotificationAction.clicked,
    );
  }

  /// Use [inAppMessageBuilder] and [notificationMessageBuilder] to build custom notification
  /// [onTap] is called when user interacts with push or inApp notification
  void buildNotification({
    required BuildContext context,
    required Map<String, dynamic> data,
    required Function(NotificationType type, String link) onTap,
    Function(InAppMessageModel)? inAppMessageBuilder,
    Function(PushNotificationMessage)? pushMessageBuilder,
  }) {
    if (NotificationAdapter.isUserComMessage(data)) {
      final notificationAdapter = NotificationAdapter.fromJson(data);

      if (notificationAdapter.type == NotificationType.inApp) {
        final inAppMessage = notificationAdapter.message as InAppMessageModel;
        if (inAppMessageBuilder != null) {
          inAppMessageBuilder(inAppMessage);
        } else {
          NotificationBuilder.buildInAppMessage(
            context: context,
            repository: _repository,
            message: inAppMessage,
            onButtonTap: (value) {
              onTap.call(NotificationType.inApp, value);
            },
          );
        }
      }
      if (notificationAdapter.type == NotificationType.push) {
        final pushMessage =
            notificationAdapter.message as PushNotificationMessage;
        if (pushMessageBuilder != null) {
          pushMessageBuilder(pushMessage);
        } else {
          if (data['from'] == _notificationChannelKey) {
            NotificationBuilder.launchCustomTab(
              repository: _repository,
              message: pushMessage,
            );
          } else {
            NotificationBuilder.buildPushNotification(
              context: context,
              repository: _repository,
              message: notificationAdapter.message as PushNotificationMessage,
              onTap: (value) {
                onTap.call(NotificationType.push, value);
              },
            );
          }
        }
      }
    }
  }

  /// Check if Firebase message is coming from User.com
  bool isUserComMessage(Map<String, dynamic> json) =>
      NotificationAdapter.isUserComMessage(json);

  /// If Firebase message data is coming from User.com, parse the message Object
  /// and retur if it's Push message. Used for displaying in terminated state.
  PushNotificationMessage? getPushMessage(Map<String, dynamic> json) {
    final notifiaction = NotificationAdapter.fromJson(json);

    if (notifiaction.type == NotificationType.push) {
      return notifiaction.message as PushNotificationMessage;
    }
    return null;
  }

  void _setupClient() {
    final service = UserApiService.create(
      cacheRepository: _cacheRepository,
      mobileSdkKey: _mobileSdkKey,
      integrationsApiKey: _integrationsApiKey,
      baseUrl: _baseUrl,
      userKey: _cacheRepository.getUserKey(),
      enableLogging: _enableLogging,
    );

    _repository = Repository(
      service: service,
      cacheRepository: _cacheRepository,
    );
  }
}
