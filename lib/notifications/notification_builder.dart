import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_user_sdk/data/repository.dart';
import 'package:flutter_user_sdk/models/events/notification_event.dart';
import 'package:flutter_user_sdk/notifications/in_app_message.dart';
import 'package:flutter_user_sdk/notifications/notification_message.dart';

class NotificationBuilder {
  static dynamic buildInAppMessage({
    required BuildContext context,
    required Repository repository,
    required InAppMessage message,
  }) {
    repository.sendNotificationEvent(
      id: message.id,
      action: NotificationAction.opened,
      type: NotificationType.inApp,
    );

    return showDialog<dynamic>(
      context: context,
      routeSettings: const RouteSettings(name: 'NotificationScreen'),
      builder: (_) => Platform.isAndroid
          ? AlertDialog(
              title: Text(message.title),
              content: Text(message.message),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                if (message.actionUrl != null)
                  ElevatedButton(
                    onPressed: () async {
                      await launch(message.actionUrl!);
                      await repository.sendNotificationEvent(
                        id: message.id,
                        action: NotificationAction.clicked,
                        type: NotificationType.inApp,
                      );
                    },
                    child: Text(message.actionBtn),
                  )
                else
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('X'),
                  ),
              ],
            )
          : CupertinoAlertDialog(
              title: Text(message.title),
              content: Text(message.message),
              actions: [
                if (message.actionUrl != null)
                  CupertinoButton(
                    onPressed: () async {
                      await launch(message.actionUrl!);
                      await repository.sendNotificationEvent(
                        id: message.id,
                        action: NotificationAction.clicked,
                        type: NotificationType.inApp,
                      );
                    },
                    child: Text(message.actionBtn),
                  )
                else
                  CupertinoButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('X'),
                  ),
              ],
            ),
    );
  }

  static dynamic buildPushNotification({
    required BuildContext context,
    required Repository repository,
    required PushNotificationMessage message,
  }) {
    repository.sendNotificationEvent(
      id: message.id,
      action: NotificationAction.opened,
      type: NotificationType.push,
    );

    Flushbar<dynamic>(
      title: message.title,
      message: message.message,
      titleColor: Colors.black87,
      messageColor: Colors.black54,
      backgroundColor: const Color(0xFFf0f0f0),
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(6),
      onTap: (_) {
        if (!message.isLinkEmpty) {
          repository.sendNotificationEvent(
            id: message.id,
            action: NotificationAction.clicked,
            type: NotificationType.push,
          );

          launch(message.link);
        } else {
          Navigator.maybePop(context);
        }
      },
    ).show(context);
  }
}
