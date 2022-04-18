import 'package:dio/dio.dart';
import 'package:flutter_user_sdk/data/interceptors/request_handler_interceptor.dart';
import 'package:retrofit/retrofit.dart';

part 'user_api_service.g.dart';

@RestApi()
abstract class UserApiService {
  factory UserApiService(Dio dio, {required String baseUrl}) = _UserApiService;

  @POST('/api/sdk/v1/ping/')
  Future<void> postPing(@Body() Map<String, dynamic> body);

  @POST('/api/sdk/v1/event/')
  Future<void> postEvent(@Body() Map<String, dynamic> body);

  static UserApiService create({
    required String mobileSdkKey,
    required String integrationsApiKey,
    required String appDomain,
    String? userKey,
  }) {
    final client = Dio()
      ..interceptors.addAll(
        [
          RequestHandlerInterceptor(
            mobileSdkKey: mobileSdkKey,
            userKey: userKey,
          ),
        ],
      );

    return _UserApiService(client, baseUrl: appDomain);
  }
}
