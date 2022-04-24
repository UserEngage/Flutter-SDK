import 'package:dio/dio.dart';
import 'package:flutter_user_sdk/data/cache_repository.dart';
import 'package:flutter_user_sdk/utils/extensions/request_options_serializer.dart';

class RequestsRetryService {
  final CacheRepository cacheRepository;

  RequestsRetryService(this.cacheRepository);

  //TODO: Implement periodic task

  void resendRequests() async {
    final cachedRequests = cacheRepository.getCachedRequests();

    for (final element in cachedRequests) {
      final requestOption = RequestOptionsSerializer.fromJson(element.object);

      await Dio().fetch<Response>(requestOption).then(
        (response) {
          if (response.statusCode == 200) {
            cacheRepository.removeRequest(key: element.key);
          }
        },
      );
    }
  }
}
