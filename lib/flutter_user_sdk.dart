library flutter_user_sdk;

import 'package:flutter_user_sdk/data/repository.dart';
import 'package:flutter_user_sdk/data/user_api_service.dart';
import 'package:flutter_user_sdk/models/events/predefined/device_information.dart';

class UserSDK {
  static UserSDK get instance => _getOrCreateInstance();
  static UserSDK? _instance;

  static UserSDK _getOrCreateInstance() {
    if (_instance != null) return _instance!;
    _instance = UserSDK();
    return _instance!;
  }

  late Repository _repository;

  void setup({
    required String mobileSdkKey,
    required String integrationsApiKey,
    required String appDomain,
  }) async {
    final service = UserApiService.create(
      mobileSdkKey: mobileSdkKey,
      integrationsApiKey: integrationsApiKey,
      appDomain: appDomain,
    );

    _repository = Repository(service: service);
  }

  // // generates new anonymous user
  // // provide userKey from previous session if You want refer to the same user
  Future<void> registerAnonymousUserSession({String? userKey}) async {
    await _repository.postUserDeviceInfo(
      userKey: userKey,
      deviceInfo: await DeviceInformation.getPlatformInformation(
            fcmToken: '',
          ) ??
          <String, dynamic>{},
    );
  }

  Future<void> sendCustomEvent({
    required String eventName,
    required Map<String, dynamic> data,
  }) async {
    await _repository.sendCustomEvent(
      eventName: eventName,
      data: data,
    );
  }

  // void register(Customer customer) {}
}
