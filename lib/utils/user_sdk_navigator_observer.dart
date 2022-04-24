import 'package:flutter/material.dart';

class UserSdkNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    //TODO: Trigger SDK event there
    super.didPush(route, previousRoute);
  }
}
