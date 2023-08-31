import 'package:dio/dio.dart';
import 'package:flutter_user_sdk/src/data/interceptors/request_handler_interceptor.dart';
import 'package:flutter_user_sdk/src/data/user_api_service.dart';

extension RequestOptionsSerializer on RequestOptions {
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'method': method,
      'sendTimeout': sendTimeout,
      'receiveTimeout': receiveTimeout?.inSeconds,
      'connectTimeout': connectTimeout?.inSeconds,
      'data': data,
      'path': path,
      'queryParameters': queryParameters,
      'onReceiveProgress': null,
      'onSendProgress': null,
      'cancelToken': null,
      'baseUrl': baseUrl,
      'extra': extra,
      'headers': headers,
      'responseType': responseType.name,
      'contentType': contentType,
      'validateStatus': null,
      'receiveDataWhenStatusError': receiveDataWhenStatusError,
      'followRedirects': followRedirects,
      'maxRedirects': maxRedirects,
      'requestEncoder': null,
      'responseDecoder': null,
      'listFormat': listFormat.name,
    };
  }

  static RequestOptions fromJson(Map<String, dynamic> json) {
    return RequestOptions(
      method: json['method'],
      sendTimeout: json['sendTimeout'],
      data: json['data'],
      path: json['path'],
      queryParameters: json['queryParameters'] ?? <String, dynamic>{},
      baseUrl: json['baseUrl'] ?? '',
      extra: json['extra'],
      headers: json['headers'],
      responseType: ResponseType.values.byName(json['responseType']),
      contentType: json['contentType'],
      validateStatus: json['validateStatus'],
      receiveDataWhenStatusError: json['receiveDataWhenStatusError'],
      followRedirects: json['followRedirects'],
      maxRedirects: json['maxRedirects'],
      requestEncoder: json['requestEncoder'],
      responseDecoder: json['responseDecoder'],
      listFormat: ListFormat.values.byName(json['listFormat']),
    );
  }

  bool get containsUserKey => (headers[userKeyHeaderKey] as String).isNotEmpty;

  void addUserKey(String key) {
    headers.addAll(<String, dynamic>{userKeyHeaderKey: key});

    if (isPingRequest) {
      (data['customer'] as Map<String, dynamic>)
          .addAll(<String, dynamic>{'userKey': key});
    }
  }

  bool get isPingRequest => uri.path == UserApiService.pingUrl;
}
