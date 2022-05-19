import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class CacheRepository {
  static const String requestsCacheBox = 'userSDKRequestsCache';
  static const String userCacheBox = 'userSDKCache';

  static const String userKeyKey = 'userk';

  late final Box requestsBox;
  late final Box box;

  Future<void> initialize() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    await Hive.openBox<dynamic>(requestsCacheBox);
    await Hive.openBox<dynamic>(userCacheBox);

    requestsBox = Hive.box<dynamic>(requestsCacheBox);
    box = Hive.box<dynamic>(userCacheBox);
  }

  void saveInvalidRequest(Map<String, dynamic> jsonRequest) {
    requestsBox.add(jsonEncode(jsonRequest));
  }

  void removeRequest({required int key}) {
    requestsBox.delete(key);
  }

  List<_HiveObject> getCachedRequests() {
    List<_HiveObject> requests = [];

    for (int i = 0; i < requestsBox.length; i++) {
      requests.add(
        _HiveObject(
          key: requestsBox.keys.toList()[i],
          object: jsonDecode(requestsBox.values.toList()[i])
              as Map<String, dynamic>,
        ),
      );
    }
    return requests;
  }

  void addUserKey(String? userKey) {
    box.put(userKeyKey, userKey);
  }

  String? getUserKey() {
    return box.get(userKeyKey);
  }

  Future<void> clearStorage() async {
    await box.clear();
    await requestsBox.clear();
  }
}

class _HiveObject {
  final int key;
  final Map<String, dynamic> object;

  _HiveObject({
    required this.key,
    required this.object,
  });
}
