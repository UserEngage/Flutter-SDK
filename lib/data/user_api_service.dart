import 'package:dio/dio.dart';
import 'package:flutter_user_sdk/data/cache_repository.dart';
import 'package:flutter_user_sdk/data/interceptors/request_handler_interceptor.dart';
import 'package:flutter_user_sdk/models/customer_extended_info.dart';
import 'package:flutter_user_sdk/models/events/custom_event.dart';
import 'package:flutter_user_sdk/models/events/logout_event.dart';
import 'package:flutter_user_sdk/models/events/screen_event.dart';
import 'package:flutter_user_sdk/models/events/product_event.dart';
import 'package:retrofit/retrofit.dart';

part 'user_api_service.g.dart';

@RestApi()
abstract class UserApiService {
  factory UserApiService(Dio dio, {required String baseUrl}) = _UserApiService;

  @POST('/api/sdk/v1/ping/')
  Future<String> postPing(@Body() CustomerExtendedInfo body);

  @POST('/api/sdk/v1/event/')
  Future<void> postEvent(@Body() CustomEvent body);

  @POST('/api/sdk/v1/screen_event/')
  Future<void> postScreenEvent(@Body() ScreenEvent body);

  @POST('/api/sdk/v1/product_event/')
  Future<void> postProductEvent(@Body() ProductEvent body);

  @POST('/api/sdk/v1/event/')
  Future<void> logoutEvent(@Body() LogoutEvent body);

  static UserApiService create({
    required String mobileSdkKey,
    String? integrationsApiKey,
    required String appDomain,
    required CacheRepository cacheRepository,
    String? userKey,
  }) {
    final client = Dio()
      ..interceptors.addAll(
        [
          RequestHandlerInterceptor(
            cacheRepository: cacheRepository,
            mobileSdkKey: mobileSdkKey,
            userKey: userKey,
          ),
          //TODO: make it optional or delete
          LogInterceptor(
            requestBody: true,
            request: false,
            requestHeader: true,
            responseBody: true,
          ),
        ],
      );

    return _UserApiService(client, baseUrl: appDomain);
  }
}
