import 'package:flutter_user_sdk/flutter_user_sdk.dart';
import 'package:flutter_user_sdk/src/notifications/notification_adapter.dart';

class PushNotificationMessage extends UserComMessage {
  final String id;
  final String title;
  final String message;
  final String link;
  // ignore: deprecated_member_use
  final NotificationType type;

  PushNotificationMessage(
    this.id,
    this.title,
    this.message,
    this.link,
  ) : type = NotificationType.push;

  bool get isLinkNotEmpty => link != 'None';

  factory PushNotificationMessage.fromJson(Map<String, dynamic> json) {
    return PushNotificationMessage(
      json['id'] as String? ?? '',
      json['title'] as String? ?? '',
      json['message'] as String? ?? '',
      json['link'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'message': message,
      'link': link,
    };
  }
}
