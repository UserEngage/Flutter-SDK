import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:root/root.dart';

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
  @JsonKey(name: 'fcm_key')
  final String fcmToken;

  DeviceInformation({
    required this.libraryVersion,
    required this.osType,
    required this.version,
    required this.sdk,
    required this.device,
    required this.model,
    required this.manufacturer,
    required this.fcmToken,
  });

  static Future<Map<String, dynamic>?> getPlatformInformation({
    required String fcmToken,
  }) async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;

      return DeviceAndroidInformation(
        //TODO: Get this from pubspec.yaml
        libraryVersion: '1',
        osType: 'Android',
        version: androidInfo.version.incremental.toString(),
        sdk: androidInfo.version.sdkInt.toString(),
        device: androidInfo.device ?? 'Unknown',
        model: androidInfo.model ?? 'Unknown',
        manufacturer: androidInfo.manufacturer ?? 'Unknown',
        fcmToken: fcmToken,
        isRoot: await Root.isRooted() ?? false,
      ).toJson();
    } else if (Platform.isIOS) {
      final iosInfo = await DeviceInfoPlugin().iosInfo;

      //TODO: Get more information for IOS device

      return DeviceIosInformation(
        //TODO: Get this from pubspec.yaml
        libraryVersion: '1',
        osType: 'IOS',
        version: iosInfo.systemVersion ?? 'Unknown',
        sdk: 'Unknown',
        device: iosInfo.identifierForVendor ?? 'Unknown',
        model: iosInfo.model ?? 'Unknown',
        manufacturer: 'Unknown',
        fcmToken: fcmToken,
        identifier: await AdvertisingId.id(true) ?? 'Permission not granted',
      ).toJson();
    }
  }
}

@JsonSerializable()
class DeviceAndroidInformation extends DeviceInformation {
  @JsonKey(name: 'is_root')
  final bool isRoot;

  DeviceAndroidInformation({
    required String libraryVersion,
    required String osType,
    required String version,
    required String sdk,
    required String device,
    required String model,
    required String manufacturer,
    required String fcmToken,
    required this.isRoot,
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
    required String fcmToken,
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
}
