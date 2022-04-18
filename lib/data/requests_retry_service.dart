import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_user_sdk/utils/extensions/request_options_serializer.dart';
import 'package:hive/hive.dart';

//TODO: Work in progress
final requestsBox = Hive.box('userSDKRequests');
final box = Hive.box('userSDKuserKey');

class RequestsRetryService {
  void initialize() async {
    await Hive.openBox('userSDKRequests');
  }

  void resendRequests() async {
    if (requestsBox.values.isEmpty) return;

    for (final element in requestsBox.values) {
      final requestJson = jsonDecode(element as String);
      final requestOption = RequestOptionsSerializer.fromJson(requestJson);

      Dio().fetch(requestOption);
    }
  }
}
