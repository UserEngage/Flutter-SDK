import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_user_sdk/data/repository.dart';

class NotificationBuilder {
  static dynamic buildNotification({
    required BuildContext context,
    Function(RemoteMessage)? builder,
    required Repository repository,
    bool openDefaultDialog = true,
    //TODO: Change to notification model
    required RemoteMessage message,
  }) {
    if (openDefaultDialog) {
      return showDialog<dynamic>(
        context: context,
        builder: (_) {
          //TODO: Mocked dialog. Pass arguments from notification model
          //repository.sendNotificationEvent(id: id, action: InAppEventAction.opened);

          return Platform.isAndroid
              ? AlertDialog(
                  title: const Text('Got message'),
                  content: const Text(
                    'We got message from firebase. Maybe open it?',
                  ),
                  actionsAlignment: MainAxisAlignment.center,
                  actions: [
                    ElevatedButton(
                      onPressed: () async {
                        // repository.sendNotificationEvent(id: id, action: InAppEventAction.clicked);
                        //TODO: Open link provided in notification data

                        await launch('https://flutter.dev/');
                      },
                      child: const Text('Check it out'),
                    ),
                  ],
                )
              : CupertinoAlertDialog(
                  title: const Text('Got message'),
                  content: const Text(
                    'We got message from firebase. Maybe open it?',
                  ),
                  actions: [
                    CupertinoButton(
                      onPressed: () async {
                        // repository.sendNotificationEvent(id: id, action: InAppEventAction.clicked);
                        //TODO: Open link provided in notification data
                        await launch('https://flutter.dev/');
                      },
                      child: const Text('Check it out'),
                    ),
                  ],
                );
        },
      );
    } else {
      return builder!(message);
    }
  }
}
