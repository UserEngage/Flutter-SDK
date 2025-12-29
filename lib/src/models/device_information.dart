import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:device_info_plus/device_info_plus.dart';

abstract class DeviceInformation {
  late String libraryVersion;
  late String osType;
  late String version;
  late String sdk;
  late String device;
  late String model;
  String manufacturer;
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

class DeviceAndroidInformation extends DeviceInformation {
  final bool? isRoot;

  DeviceAndroidInformation({
    required super.libraryVersion,
    required super.osType,
    required super.version,
    required super.sdk,
    required super.device,
    required super.model,
    required super.manufacturer,
    super.fcmToken,
    this.isRoot,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'lib_version': libraryVersion,
      'os_type': osType,
      'version': version,
      'sdk': sdk,
      'device': device,
      'model': model,
      'manufacturer': manufacturer,
    };
    if (fcmToken != null) map['fcm_key'] = fcmToken;
    if (isRoot != null) map['is_root'] = isRoot;
    return map;
  }

  factory DeviceAndroidInformation.fromJson(Map<String, dynamic> json) {
    return DeviceAndroidInformation(
      libraryVersion:
          json['lib_version'] as String? ?? DeviceInformation.libVersion,
      osType: json['os_type'] as String? ?? DeviceInformation.unknown,
      version: json['version'] as String? ?? DeviceInformation.unknown,
      sdk: json['sdk'] as String? ?? DeviceInformation.unknown,
      device: json['device'] as String? ?? DeviceInformation.unknown,
      model: json['model'] as String? ?? DeviceInformation.unknown,
      manufacturer:
          json['manufacturer'] as String? ?? DeviceInformation.unknown,
      fcmToken: json['fcm_key'] as String?,
      isRoot: json['is_root'] as bool?,
    );
  }
}

class DeviceIosInformation extends DeviceInformation {
  final String identifier;

  DeviceIosInformation({
    required super.libraryVersion,
    required super.osType,
    required super.version,
    required super.sdk,
    required super.device,
    required super.model,
    required super.manufacturer,
    super.fcmToken,
    required this.identifier,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'lib_version': libraryVersion,
      'os_type': osType,
      'version': version,
      'sdk': sdk,
      'device': device,
      'model': model,
      'manufacturer': manufacturer,
      'identifier': identifier,
    };
    if (fcmToken != null) map['fcm_key'] = fcmToken;
    return map;
  }

  factory DeviceIosInformation.fromJson(Map<String, dynamic> json) {
    return DeviceIosInformation(
      libraryVersion:
          json['lib_version'] as String? ?? DeviceInformation.libVersion,
      osType: json['os_type'] as String? ?? DeviceInformation.unknown,
      version: json['version'] as String? ?? DeviceInformation.unknown,
      sdk: json['sdk'] as String? ?? DeviceInformation.unknown,
      device: json['device'] as String? ?? DeviceInformation.unknown,
      model: json['model'] as String? ?? DeviceInformation.unknown,
      manufacturer:
          json['manufacturer'] as String? ?? DeviceInformation.unknown,
      fcmToken: json['fcm_key'] as String?,
      identifier: json['identifier'] as String? ?? DeviceInformation.unknown,
    );
  }
}
