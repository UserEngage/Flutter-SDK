// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_information.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceAndroidInformation _$DeviceAndroidInformationFromJson(
        Map<String, dynamic> json) =>
    DeviceAndroidInformation(
      libraryVersion: json['lib_version'] as String,
      osType: json['os_type'] as String,
      version: json['version'] as String,
      sdk: json['sdk'] as String,
      device: json['device'] as String,
      model: json['model'] as String,
      manufacturer: json['manufacturer'] as String,
      fcmToken: json['fcm_key'] as String,
      isRoot: json['is_root'] as bool,
    );

Map<String, dynamic> _$DeviceAndroidInformationToJson(
        DeviceAndroidInformation instance) =>
    <String, dynamic>{
      'lib_version': instance.libraryVersion,
      'os_type': instance.osType,
      'version': instance.version,
      'sdk': instance.sdk,
      'device': instance.device,
      'model': instance.model,
      'manufacturer': instance.manufacturer,
      'fcm_key': instance.fcmToken,
      'is_root': instance.isRoot,
    };

DeviceIosInformation _$DeviceIosInformationFromJson(
        Map<String, dynamic> json) =>
    DeviceIosInformation(
      libraryVersion: json['lib_version'] as String,
      osType: json['os_type'] as String,
      version: json['version'] as String,
      sdk: json['sdk'] as String,
      device: json['device'] as String,
      model: json['model'] as String,
      manufacturer: json['manufacturer'] as String,
      fcmToken: json['fcm_key'] as String,
      identifier: json['identifier'] as String,
    );

Map<String, dynamic> _$DeviceIosInformationToJson(
        DeviceIosInformation instance) =>
    <String, dynamic>{
      'lib_version': instance.libraryVersion,
      'os_type': instance.osType,
      'version': instance.version,
      'sdk': instance.sdk,
      'device': instance.device,
      'model': instance.model,
      'manufacturer': instance.manufacturer,
      'fcm_key': instance.fcmToken,
      'identifier': instance.identifier,
    };
