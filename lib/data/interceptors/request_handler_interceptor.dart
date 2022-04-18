import 'package:dio/dio.dart';
import 'package:flutter_user_sdk/utils/extensions/request_options_serializer.dart';

class RequestHandlerInterceptor implements Interceptor {
  final String mobileSdkKey;
  final String? userKey;
  final Map<String, String> customHeaders;

  RequestHandlerInterceptor({
    required this.mobileSdkKey,
    this.userKey,
  }) : customHeaders = <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Token $mobileSdkKey',
          'userKey': userKey ?? '',
        };

  late RequestOptions? _currentRequestOptions;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll(customHeaders);

    _currentRequestOptions = options;

    return handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.type != DioErrorType.response) {
      final jsonOptions = _currentRequestOptions!.toJson();

      final newRequestOptionsObject =
          RequestOptionsSerializer.fromJson(jsonOptions);

      //TODO: Save requestOption to database with extended object - timestamp and retries
    }
    return handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }
}
