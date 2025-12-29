import 'package:dio/dio.dart';

import 'package:flutter_user_sdk/src/data/cache_repository.dart';
import 'package:flutter_user_sdk/src/data/interceptors/request_handler_interceptor.dart';
import 'package:flutter_user_sdk/src/models/customer_extended_info.dart';
import 'package:flutter_user_sdk/src/models/events/custom_event.dart';
import 'package:flutter_user_sdk/src/models/events/notification_event.dart';
import 'package:flutter_user_sdk/src/models/events/logout_event.dart';
import 'package:flutter_user_sdk/src/models/events/product_event.dart';
import 'package:flutter_user_sdk/src/models/events/screen_event.dart';

abstract class UserApiService {
  static const String pingUrl = '/api/sdk/v1/ping/';
  static const String eventUrl = '/api/sdk/v1/event/';
  static const String screenEventUrl = '/api/sdk/v1/screen_event/';
  static const String productEventUrl = '/api/sdk/v1/product_event/';
  static const String logoutUrl = '/api/sdk/v1/event/';
  static const String notificationUrl = '/api/sdk/v1/{type}/{id}/{action}/';

  Future<String> postPing(CustomerExtendedInfo body);

  Future<void> postEvent(CustomEvent body);

  Future<void> postScreenEvent(ScreenEvent body);

  Future<void> postProductEvent(ProductEvent body);

  Future<void> logoutEvent(LogoutEvent body);

  Future<void> notificationEvent(
    String id,
    String type,
    String action,
    NotificationEvent event,
  );

  static UserApiService create({
    required String mobileSdkKey,
    String? integrationsApiKey,
    required String baseUrl,
    required CacheRepository cacheRepository,
    String? userKey,
    bool enableLogging = false,
  }) {
    final client = Dio(BaseOptions(baseUrl: baseUrl))
      ..interceptors.addAll([
        RequestHandlerInterceptor(
          cacheRepository: cacheRepository,
          mobileSdkKey: mobileSdkKey,
        ),
        if (enableLogging)
          LogInterceptor(
            requestBody: true,
            request: false,
            requestHeader: false,
            responseHeader: false,
            responseBody: true,
          ),
      ]);

    if (integrationsApiKey != null && integrationsApiKey.isNotEmpty) {
      client.options.headers['Integrations-Api-Key'] = integrationsApiKey;
    }
    if (userKey != null && userKey.isNotEmpty) {
      client.options.headers['User-Key'] = userKey;
    }

    return _UserApiServiceImpl(client, baseUrl: baseUrl);
  }
}

class _UserApiServiceImpl implements UserApiService {
  _UserApiServiceImpl(this._dio, {String? baseUrl}) {
    if (baseUrl != null && baseUrl.isNotEmpty) {
      _dio.options.baseUrl = baseUrl;
    }
  }

  final Dio _dio;

  @override
  Future<String> postPing(CustomerExtendedInfo body) async {
    final Response<String> response = await _dio.post<String>(
      UserApiService.pingUrl,
      data: body.toJson(),
      options: Options(responseType: ResponseType.plain),
    );

    return response.data ?? '';
  }

  @override
  Future<void> postEvent(CustomEvent body) async {
    await _dio.post(UserApiService.eventUrl, data: body.toJson());
  }

  @override
  Future<void> postScreenEvent(ScreenEvent body) async {
    await _dio.post(UserApiService.screenEventUrl, data: body.toJson());
  }

  @override
  Future<void> postProductEvent(ProductEvent body) async {
    await _dio.post(UserApiService.eventUrl, data: body.toJson());
  }

  @override
  Future<void> logoutEvent(LogoutEvent body) async {
    await _dio.post(UserApiService.eventUrl, data: body.toJson());
  }

  @override
  Future<void> notificationEvent(
    String id,
    String type,
    String action,
    NotificationEvent event,
  ) async {
    final url = UserApiService.notificationUrl
        .replaceAll('{type}', type)
        .replaceAll('{id}', id)
        .replaceAll('{action}', action);

    await _dio.post(url, data: event.toJson());
  }
}
