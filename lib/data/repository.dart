import 'dart:convert';

import 'package:flutter_user_sdk/data/cache_repository.dart';
import 'package:flutter_user_sdk/data/user_api_service.dart';
import 'package:flutter_user_sdk/models/customer.dart';
import 'package:flutter_user_sdk/models/customer_extended_info.dart';
import 'package:flutter_user_sdk/models/events/custom_event.dart';
import 'package:flutter_user_sdk/models/events/logout_event.dart';
import 'package:flutter_user_sdk/models/events/product_event.dart';
import 'package:flutter_user_sdk/models/events/screen_event.dart';

class Repository {
  final UserApiService service;
  final CacheRepository cacheRepository;

  Repository({
    required this.service,
    required this.cacheRepository,
  });

  Future<void> postUserDeviceInfo({
    String? userKey,
    required Map<String, dynamic> deviceInfo,
  }) async {
    try {
      final key = userKey ?? cacheRepository.getUserKey();

      final result = await service.postPing(
        CustomerExtendedInfo(
          customer: Customer(userKey: key),
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

  // Future<void> register(Customer customer) async {
  //   final result = await userClient.dio.post(
  //     _REGISTER_ENDPOINT,
  //     data: <String, dynamic>{},
  //   );
  // }
}
