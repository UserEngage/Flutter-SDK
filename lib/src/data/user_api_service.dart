import 'package:dio/dio.dart';

import 'package:flutter_user_sdk/src/data/cache_repository.dart';
import 'package:flutter_user_sdk/src/data/interceptors/request_handler_interceptor.dart';
import 'package:flutter_user_sdk/src/models/customer_extended_info.dart';
import 'package:flutter_user_sdk/src/models/events/custom_event.dart';
import 'package:flutter_user_sdk/src/models/events/notification_event.dart';
import 'package:flutter_user_sdk/src/models/events/logout_event.dart';
import 'package:flutter_user_sdk/src/models/events/product_event.dart';
import 'package:flutter_user_sdk/src/models/events/screen_event.dart';

import 'package:retrofit/retrofit.dart';

part 'user_api_service.g.dart';

@RestApi()
abstract class UserApiService {
  factory UserApiService(Dio dio, {required String baseUrl}) = _UserApiService;

  static const String pingUrl = '/api/sdk/v1/ping/';
  static const String eventUrl = '/api/sdk/v1/event/';
  static const String screenEventUrl = '/api/sdk/v1/screen_event/';
  static const String productEventUrl = '/api/sdk/v1/product_event/';
  static const String logoutUrl = '/api/sdk/v1/event/';
  static const String notificationUrl = '/api/sdk/v1/{type}/{id}/{action}/';

  @POST(pingUrl)
  Future<String> postPing(@Body() CustomerExtendedInfo body);

  @POST(eventUrl)
  Future<void> postEvent(@Body() CustomEvent body);

  @POST(screenEventUrl)
  Future<void> postScreenEvent(@Body() ScreenEvent body);

  @POST(productEventUrl)
  Future<void> postProductEvent(@Body() ProductEvent body);

  @POST(logoutUrl)
  Future<void> logoutEvent(@Body() LogoutEvent body);

  @POST(notificationUrl)
  Future<void> notificationEvent(
    @Path() String id,
    @Path() String type,
    @Path() String action,
    @Body() NotificationEvent event,
  );

  static UserApiService create({
    required String mobileSdkKey,
    String? integrationsApiKey,
    required String appDomain,
    required CacheRepository cacheRepository,
    String? userKey,
    bool enableLogging = false,
  }) {
    final client = Dio()
      ..interceptors.addAll(
        [
          RequestHandlerInterceptor(
            cacheRepository: cacheRepository,
            mobileSdkKey: mobileSdkKey,
            userKey: userKey,
          ),
          if (enableLogging)
            LogInterceptor(
              requestBody: true,
              request: false,
              requestHeader: false,
              responseHeader: false,
              responseBody: true,
            ),
        ],
      );

    return _UserApiService(client, baseUrl: appDomain);
  }
}
