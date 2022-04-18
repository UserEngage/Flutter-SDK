import 'package:flutter_user_sdk/data/user_api_service.dart';

class Repository {
  final UserApiService service;
  Repository({required this.service});

  Future<String?> postUserDeviceInfo({
    String? userKey,
    required Map<String, dynamic> deviceInfo,
  }) async {
    try {
      //TODO: Create model for postPing argument
      final result = await service.postPing(
        <String, dynamic>{
          "customer": {
            "userKey": userKey,
          },
          "device": deviceInfo
        },
      );
    } catch (_) {}

    //TODO: Save returned key to database and use it in ping if already exists

    return null;

    //return result.body['user']['key'] as String;
  }

  Future<void> sendCustomEvent({
    required String eventName,
    required Map<String, dynamic> data,
  }) async {
    try {
      //TODO: Create model for postEvent argument
      final result = await service.postEvent(
        <String, dynamic>{
          "event": eventName,
          "timestamp": DateTime.now().toIso8601String(),
          "data": data,
        },
      );
    } catch (_) {}
  }

  // Future<void> register(Customer customer) async {
  //   final result = await userClient.dio.post(
  //     _REGISTER_ENDPOINT,
  //     data: <String, dynamic>{},
  //   );
  // }
}
