import 'package:dio/dio.dart';
import 'package:flutter_user_sdk/data/cache_repository.dart';
import 'package:flutter_user_sdk/utils/connection_service.dart';
import 'package:flutter_user_sdk/utils/extensions/request_options_serializer.dart';

class RequestsRetryService {
  final CacheRepository cacheRepository;

  RequestsRetryService(this.cacheRepository);

  final dio = Dio();

  void resendRequests() async {
    if (!ConnectionService.instance.isConnected) return;

    final cachedRequests = cacheRepository.getCachedRequests();

    for (final element in cachedRequests) {
      final requestOption = RequestOptionsSerializer.fromJson(element.object);

      final userKey = cacheRepository.getUserKey();

      if (requestOption.containsUserKey) {
        _sendRequest(requestOption, element.key);
      } else if (userKey != null && !requestOption.containsUserKey) {
        requestOption.addUserKey(userKey);
        _sendRequest(requestOption, element.key);
      }
    }
  }

  void _sendRequest(RequestOptions requestOption, int key) {
    try {
      dio.fetch<dynamic>(requestOption).then(
        (response) {
          if (response.statusCode == 200) {
            cacheRepository.removeRequest(key: key);
          }
        },
      );
    } catch (_) {}
  }
}
