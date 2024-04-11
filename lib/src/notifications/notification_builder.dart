import 'dart:async';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_user_sdk/src/data/repository.dart';
import 'package:flutter_user_sdk/src/models/events/notification_event.dart';
import 'package:flutter_user_sdk/src/models/in_app_message_model.dart';
import 'package:flutter_user_sdk/src/models/notification_message.dart';
import 'package:flutter_user_sdk/src/notifications/in_app_message/dialog_container.dart';
import 'package:flutter_user_sdk/src/notifications/in_app_message/in_app_button.dart';
import 'package:flutter_user_sdk/src/notifications/in_app_message/in_app_image.dart';
import 'package:flutter_user_sdk/src/notifications/in_app_message/in_app_text.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationBuilder {
  static dynamic buildInAppMessage({
    required BuildContext context,
    required Repository repository,
    required InAppMessageModel message,
    required Function(String value) onButtonTap,
  }) {
    repository.sendNotificationEvent(
      id: message.id,
      action: NotificationAction.displayed,
      type: NotificationType.inApp,
    );

    return showGeneralDialog<dynamic>(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Padding(
          padding: const EdgeInsets.all(26.0),
          child: Align(
            alignment: message.alignment,
            child: DialogContainer(
              message: message,
              repository: repository,
              children: message.items.map(
                (item) {
                  if (item is InAppMessageTextModel) {
                    return InAppText(model: item);
                  } else if (item is InAppMessageImageModel) {
                    return InAppImage(model: item);
                  } else if (item is InAppButtonModel) {
                    return InAppButton(
                      model: item,
                      onTap: (value) {
                        onButtonTap(value);
                        repository.sendNotificationEvent(
                          id: message.id,
                          action: NotificationAction.clicked,
                          type: NotificationType.inApp,
                          url: value.isEmpty ? null : value,
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ).toList(),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 700),
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(anim1),
          child: child,
        );
      },
    );
  }

  static dynamic buildPushNotification({
    required BuildContext context,
    required Repository repository,
    required PushNotificationMessage message,
    Function(String link)? onTap,
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
      onTap: (_) {
        repository.sendNotificationEvent(
          id: message.id,
          action: NotificationAction.clicked,
          type: NotificationType.push,
        );

        onTap?.call(message.link);
      },
    ).show(context);
    repository.sendNotificationEvent(
      id: message.id,
      action: NotificationAction.displayed,
      type: NotificationType.push,
    );
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
