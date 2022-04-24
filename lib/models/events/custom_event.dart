class CustomEvent {
  final String event;
  final DateTime timestamp;
  final Map<String, dynamic> data;
  CustomEvent({
    required this.event,
    required this.timestamp,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'event': event,
      'timestamp': timestamp.toIso8601String(),
      'data': data,
    };
  }

  factory CustomEvent.fromJson(Map<String, dynamic> json) {
    return CustomEvent(
      event: json['event'] as String? ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
      data: Map<String, dynamic>.from(json['data'] as Map<String, dynamic>),
    );
  }
}
