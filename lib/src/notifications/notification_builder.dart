import 'dart:async';
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_user_sdk/src/data/repository.dart';
import 'package:flutter_user_sdk/src/models/events/notification_event.dart';
import 'package:flutter_user_sdk/src/notifications/in_app_message.dart';
import 'package:flutter_user_sdk/src/notifications/notification_message.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationBuilder {
  static dynamic buildInAppMessage({
    required BuildContext context,
    required Repository repository,
    required InAppMessage message,
  }) {
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
                      unawaited(
                        repository.sendNotificationEvent(
                          id: message.id,
                          action: NotificationAction.clicked,
                          type: NotificationType.inApp,
                        ),
                      );

                      await launchUrl(Uri.parse(message.actionUrl!)).then(
                        (_) => Navigator.pop(context),
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
                      unawaited(
                        repository.sendNotificationEvent(
                          id: message.id,
                          action: NotificationAction.clicked,
                          type: NotificationType.inApp,
                        ),
                      );

                      await launchUrl(Uri.parse(message.actionUrl!)).then(
                        (_) => Navigator.pop(context),
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
    Flushbar<dynamic>(
      title: message.title,
      message: message.message,
      titleColor: Colors.black87,
      messageColor: Colors.black54,
      backgroundColor: const Color(0xFFfafafa),
      duration: const Duration(seconds: 12),
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(6),
      onTap: (_) async {
        if (message.isLinkNotEmpty) {
          unawaited(
            repository.sendNotificationEvent(
              id: message.id,
              action: NotificationAction.clicked,
              type: NotificationType.push,
            ),
          );

          await launchUrl(Uri.parse(message.link)).then(
            (_) => Navigator.maybePop(context),
          );
        } else {
          await Navigator.maybePop(context);
        }
      },
    ).show(context);
  }

  static Future<void> launchCustomTab({
    required Repository repository,
    required PushNotificationMessage message,
  }) async {
    if (message.isLinkNotEmpty) {
      unawaited(
        repository.sendNotificationEvent(
          id: message.id,
          action: NotificationAction.clicked,
          type: NotificationType.push,
        ),
      );

      await launchUrl(Uri.parse(message.link));
    }
  }
}
