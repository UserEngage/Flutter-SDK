library flutter_user_sdk;

import 'package:flutter/material.dart';
import 'package:flutter_user_sdk/data/cache_repository.dart';
import 'package:flutter_user_sdk/data/repository.dart';
import 'package:flutter_user_sdk/data/requests_retry_service.dart';
import 'package:flutter_user_sdk/data/user_api_service.dart';
import 'package:flutter_user_sdk/models/customer.dart';
import 'package:flutter_user_sdk/models/events/custom_event.dart';
import 'package:flutter_user_sdk/models/events/product_event.dart';
import 'package:flutter_user_sdk/models/events/screen_event.dart';
import 'package:flutter_user_sdk/notifications/notification_builder.dart';
import 'package:flutter_user_sdk/notifications/notification_service.dart';
import 'package:flutter_user_sdk/utils/connection_service.dart';

class UserSDK {
  static UserSDK get instance => _getOrCreateInstance();
  static UserSDK? _instance;

  static UserSDK _getOrCreateInstance() {
    if (_instance != null) return _instance!;
    _instance = UserSDK();
    return _instance!;
  }

  late String _mobileSdkKey;

  String? _integrationsApiKey;

  late String _appDomain;

  late Repository _repository;

  late CacheRepository _cacheRepository;

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

    await ConnectionService.instance.initialize();

    _setupClient();

    String? fcmToken;

    await NotificationService.initialize(
      onTokenReceived: (token) => fcmToken = token,
    );

    await registerAnonymousUserSession(fcmToken: fcmToken);

    RequestsRetryService(_cacheRepository).resendRequests();
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

  void buildNotificationOnMessageReceived(BuildContext context) {
    if (!NotificationService.messageController.hasListener) {
      NotificationService.messageController.stream.listen(
        (message) {
          NotificationBuilder.buildNotification(
            context: context,
            repository: _repository,
            message: message,
          );
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
