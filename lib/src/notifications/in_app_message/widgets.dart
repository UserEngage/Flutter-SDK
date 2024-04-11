import 'package:flutter/material.dart';
import 'package:flutter_user_sdk/flutter_user_sdk.dart';
import 'package:flutter_user_sdk/src/data/repository.dart';
import 'package:flutter_user_sdk/src/models/in_app_message_model.dart';

class InAppExitButton extends StatelessWidget {
  const InAppExitButton({
    super.key,
    required this.inAppMessage,
    required this.repository,
  });

  final InAppMessageModel inAppMessage;
  final Repository repository;

  @override
  Widget build(BuildContext context) {
    return inAppMessage.exitButton.visible
        ? Padding(
            padding: inAppMessage.exitButton.margin,
            child: IconButton(
              onPressed: () {
                repository.sendNotificationEvent(
                  id: inAppMessage.id,
                  type: NotificationType.inApp,
                  action: NotificationAction.dismissed,
                );
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.clear,
                color: inAppMessage.exitButton.color,
              ),
            ),
          )
        : const SizedBox();
  }
}
