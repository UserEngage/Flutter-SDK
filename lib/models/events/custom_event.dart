import 'dart:convert';

class CustomEvent {
  final String event;
  final DateTime timestamp;
  final Map<String, dynamic> data;
  CustomEvent({
    required this.event,
    required this.timestamp,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'event': event,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'data': data,
    };
  }

  factory CustomEvent.fromMap(Map<String, dynamic> map) {
    return CustomEvent(
      event: map['event'] ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      data: Map<String, dynamic>.from(map['data']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomEvent.fromJson(String source) =>
      CustomEvent.fromMap(json.decode(source));
}
