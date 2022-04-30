enum InAppEventAction { clicked, opened }

class InAppEvent {
  final String id;
  final InAppEventAction action;

  final String eventName;
  final DateTime timestamp;

  InAppEvent({
    required this.id,
    required this.action,
  })  : eventName = "NotificationEvent",
        timestamp = DateTime.now();

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "data": {
        "notification_action": action.name,
        "in_app_message_delivery_id": id
      },
      "event": eventName,
      "timestamp": timestamp.toIso8601String()
    };
  }
}
