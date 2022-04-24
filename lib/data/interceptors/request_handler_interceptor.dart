import 'package:dio/dio.dart';
import 'package:flutter_user_sdk/data/cache_repository.dart';
import 'package:flutter_user_sdk/utils/extensions/request_options_serializer.dart';

class RequestHandlerInterceptor implements Interceptor {
  final String mobileSdkKey;
  final String? userKey;
  final CacheRepository cacheRepository;
  final Map<String, String> customHeaders;

  RequestHandlerInterceptor({
    required this.mobileSdkKey,
    required this.cacheRepository,
    this.userKey,
  }) : customHeaders = <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Token $mobileSdkKey',
          'X-User-Key': userKey ?? '',
        };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll(customHeaders);

    return handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.type != DioErrorType.response) {
      final jsonOptions = err.requestOptions.toJson();

      cacheRepository.saveInvalidRequest(jsonOptions);
    }
    return handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }
}
