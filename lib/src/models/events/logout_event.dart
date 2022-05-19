class LogoutEvent {
  const LogoutEvent();

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'event': 'logout',
      'logout': true,
    };
  }
}
