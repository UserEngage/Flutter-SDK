class CustomEvent {
  final String event;
  final DateTime timestamp;
  final Map<String, dynamic> data;
  CustomEvent({
    required this.event,
    required this.data,
  }) : timestamp = DateTime.now();

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'event': event,
      'timestamp': timestamp.toIso8601String(),
      'data': data,
    };
  }
}
