import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device_information.g.dart';

abstract class DeviceInformation {
  @JsonKey(name: 'lib_version')
  late String libraryVersion;
  @JsonKey(name: 'os_type')
  late String osType;
  @JsonKey(name: 'version')
  late String version;
  @JsonKey(name: 'sdk')
  late String sdk;
  @JsonKey(name: 'device')
  late String device;
  @JsonKey(name: 'model')
  late String model;
  @JsonKey(name: 'manufacturer')
  String manufacturer;
  @JsonKey(name: 'fcm_key', includeIfNull: false)
  final String? fcmToken;

  DeviceInformation({
    required this.libraryVersion,
    required this.osType,
    required this.version,
    required this.sdk,
    required this.device,
    required this.model,
    required this.manufacturer,
    this.fcmToken,
  });

  static const String unknown = 'Unknown';
  static const String android = 'Android';
  static const String ios = 'IOS';
  static const String libVersion = '0.0.5';

  static Future<Map<String, dynamic>> getPlatformInformation({
    String? fcmToken,
  }) async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;

      return DeviceAndroidInformation(
        libraryVersion: libVersion,
        osType: android,
        version: androidInfo.version.incremental.toString(),
        sdk: androidInfo.version.sdkInt.toString(),
        device: androidInfo.device,
        model: androidInfo.model,
        manufacturer: androidInfo.manufacturer,
        fcmToken: fcmToken,
      ).toJson();
    } else if (Platform.isIOS) {
      final iosInfo = await DeviceInfoPlugin().iosInfo;

      return DeviceIosInformation(
        libraryVersion: libVersion,
        osType: ios,
        version: iosInfo.systemVersion,
        sdk: iosInfo.systemVersion,
        device: iosInfo.identifierForVendor ?? unknown,
        model: iosInfo.model,
        manufacturer: iosInfo.name,
        fcmToken: fcmToken,
        identifier: await AdvertisingId.id(true) ?? unknown,
      ).toJson();
    }
    return <String, dynamic>{};
  }
}

@JsonSerializable()
class DeviceAndroidInformation extends DeviceInformation {
  @JsonKey(name: 'is_root', includeIfNull: false)
  final bool? isRoot;

  DeviceAndroidInformation({
    required String libraryVersion,
    required String osType,
    required String version,
    required String sdk,
    required String device,
    required String model,
    required String manufacturer,
    String? fcmToken,
    this.isRoot,
  }) : super(
          libraryVersion: libraryVersion,
          osType: osType,
          version: version,
          sdk: sdk,
          device: device,
          model: model,
          manufacturer: manufacturer,
          fcmToken: fcmToken,
        );

  Map<String, dynamic> toJson() => _$DeviceAndroidInformationToJson(this);

  factory DeviceAndroidInformation.fromJson(Map<String, dynamic> json) =>
      _$DeviceAndroidInformationFromJson(json);
}

@JsonSerializable()
class DeviceIosInformation extends DeviceInformation {
  final String identifier;

  DeviceIosInformation({
    required String libraryVersion,
    required String osType,
    required String version,
    required String sdk,
    required String device,
    required String model,
    required String manufacturer,
    String? fcmToken,
    required this.identifier,
  }) : super(
          libraryVersion: libraryVersion,
          osType: osType,
          version: version,
          sdk: sdk,
          device: device,
          model: model,
          manufacturer: manufacturer,
          fcmToken: fcmToken,
        );

  Map<String, dynamic> toJson() => _$DeviceIosInformationToJson(this);

  factory DeviceIosInformation.fromJson(Map<String, dynamic> json) =>
      _$DeviceIosInformationFromJson(json);
}
