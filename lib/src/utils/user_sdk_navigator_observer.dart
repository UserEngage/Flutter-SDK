import 'package:flutter/material.dart';
import 'package:flutter_user_sdk/src/user_com_sdk.dart';

class UserSdkNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    if (route.settings.name != '/') {
      UserComSDK.instance.sendScreenEvent(
        screenName: route.settings.name ?? 'unnamed',
      );
    }

    super.didPush(route, previousRoute);
  }
}
