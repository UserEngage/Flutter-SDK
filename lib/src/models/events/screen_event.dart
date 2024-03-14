enum ScreenEventType { opened }

class ScreenEvent {
  final String screenName;
  final ScreenEventType event;

  ScreenEvent({
    required this.screenName,
    this.event = ScreenEventType.opened,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'data': {
        'event': event.name,
        'screen_name': screenName,
      },
      'event': 'ScreenEvent',
    };
  }
}
