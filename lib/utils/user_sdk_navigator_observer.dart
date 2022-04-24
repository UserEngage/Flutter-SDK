import 'package:flutter/material.dart';
import 'package:flutter_user_sdk/flutter_user_sdk.dart';

class UserSdkNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    UserSDK.instance.sendScreenEvent(
      screenName: route.settings.name ?? 'unnamed',
    );
    super.didPush(route, previousRoute);
  }
}
