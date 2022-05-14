import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_user_sdk/data/cache_repository.dart';
import 'package:flutter_user_sdk/utils/connection_service.dart';
import 'package:flutter_user_sdk/utils/extensions/request_options_serializer.dart';

class RequestsRetryService {
  final CacheRepository cacheRepository;

  RequestsRetryService(this.cacheRepository);

  final dio = Dio();

  void resendRequests({VoidCallback? onUserKeyChanged}) async {
    if (!ConnectionService.instance.isConnected) return;

    final cachedRequests = cacheRepository.getCachedRequests();

    log('Resending cached requests: ${cachedRequests.length}');

    for (final element in cachedRequests) {
      final requestOption = RequestOptionsSerializer.fromJson(element.object);

      final userKey = cacheRepository.getUserKey();

      if (userKey != null) {
        requestOption.addUserKey(userKey);
      }

      if (requestOption.containsUserKey) {
        await _sendRequest(requestOption, element.key);
      } else if (requestOption.isPingRequest) {
        final result = await _sendRequest(requestOption, element.key);

        cacheRepository.addUserKey(jsonDecode(result?.data)['user']['key']);
        if (onUserKeyChanged != null) onUserKeyChanged();
      }
    }
  }

  Future<Response?> _sendRequest(RequestOptions requestOption, int key) async {
    try {
      return await dio.fetch<dynamic>(requestOption).then(
        (response) {
          if ([200, 201, 202].contains(response.statusCode)) {
            cacheRepository.removeRequest(key: key);
          }
          log('Request ${requestOption.uri} sent');
          return response;
        },
      );
    } catch (ex) {
      log('Could not send cached request. Exception: $ex');
      return null;
    }
  }
}
