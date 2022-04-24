import 'package:dio/dio.dart';
import 'package:flutter_user_sdk/data/cache_repository.dart';
import 'package:flutter_user_sdk/data/interceptors/request_handler_interceptor.dart';
import 'package:flutter_user_sdk/models/customer_extended_info.dart';
import 'package:flutter_user_sdk/models/events/custom_event.dart';
import 'package:retrofit/retrofit.dart';

part 'user_api_service.g.dart';

@RestApi()
abstract class UserApiService {
  factory UserApiService(Dio dio, {required String baseUrl}) = _UserApiService;

  @POST('/api/sdk/v1/ping/')
  Future<String> postPing(@Body() CustomerExtendedInfo body);

  @POST('/api/sdk/v1/event/')
  Future<String> postEvent(@Body() CustomEvent body);

  static UserApiService create({
    required String mobileSdkKey,
    required String integrationsApiKey,
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
