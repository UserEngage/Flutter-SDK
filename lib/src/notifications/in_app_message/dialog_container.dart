import 'package:flutter/material.dart';
import 'package:flutter_user_sdk/src/models/in_app_message_model.dart';
import 'package:flutter_user_sdk/src/notifications/in_app_message/widgets.dart';

class DialogContainer extends StatelessWidget {
  const DialogContainer({
    super.key,
    required this.message,
    this.children = const [],
  });
  final InAppMessageModel message;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: message.background.color,
          image: message.background.isValidUrl
              ? DecorationImage(
                  image: NetworkImage(message.background.imageUrl),
                  fit: BoxFit.cover,
                )
              : null,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisSize:
              message.isFullscreen ? MainAxisSize.max : MainAxisSize.min,
          children: [
            Align(
              alignment: message.exitButton.alignment,
              child: InAppExitButton(exitButtonModel: message.exitButton),
            ),
            if (message.isFullscreen)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: children,
                ),
              )
            else
              ...children,
          ],
        ),
      ),
    );
  }
}
