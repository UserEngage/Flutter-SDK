enum NotificationAction { displayed, clicked, dismissed }

enum NotificationType {
  push('1'),
  inApp('4');

  final String value;
  const NotificationType(this.value);
}

class NotificationEvent {
  final String id;
  final NotificationAction action;
  final String? url;

  final String type;
  final String deliveryIdKey;
  final DateTime timestamp;

  NotificationEvent.inApp({
    required this.id,
    required this.action,
    this.url,
  })  : type = 'in-app-message',
        deliveryIdKey = "in_app_message_delivery_id",
        timestamp = DateTime.now().toUtc();

  NotificationEvent.push({
    required this.id,
    required this.action,
    this.url,
  })  : type = 'push-notification',
        deliveryIdKey = "push_notification_delivery_id",
        timestamp = DateTime.now().toUtc();

  Map<String, dynamic> toJson() {
    return <String, dynamic>{"url": url};
  }
}
