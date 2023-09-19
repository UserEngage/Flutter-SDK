import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_user_sdk/src/data/cache_repository.dart';
import 'package:flutter_user_sdk/src/utils/extensions/request_options_serializer.dart';

const String userKeyHeaderKey = 'X-User-Key';

class RequestHandlerInterceptor implements Interceptor {
  final String mobileSdkKey;

  final CacheRepository cacheRepository;

  RequestHandlerInterceptor({
    required this.mobileSdkKey,
    required this.cacheRepository,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll(
      <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Token $mobileSdkKey',
        userKeyHeaderKey: cacheRepository.getUserKey() ?? '',
      },
    );

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final bool isNoInternetError = err.error is SocketException ||
        <DioExceptionType>[
          DioExceptionType.connectionTimeout,
          DioExceptionType.receiveTimeout,
          DioExceptionType.sendTimeout,
        ].contains(err.type);

    if (isNoInternetError) {
      final jsonOptions = err.requestOptions.toJson();

      cacheRepository.saveInvalidRequest(jsonOptions);

      log('Saved request to local cache');
    }
    return handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }
}
