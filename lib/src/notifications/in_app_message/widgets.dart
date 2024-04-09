import 'package:flutter/material.dart';
import 'package:flutter_user_sdk/src/models/in_app_message_model.dart';

class InAppExitButton extends StatelessWidget {
  const InAppExitButton({
    super.key,
    required this.exitButtonModel,
  });

  final ExitButtonModel exitButtonModel;

  @override
  Widget build(BuildContext context) {
    return exitButtonModel.visible
        ? Padding(
            padding: exitButtonModel.margin,
            child: IconButton(
              onPressed: Navigator.of(context).pop,
              icon: Icon(
                Icons.clear,
                color: exitButtonModel.color,
              ),
            ),
          )
        : const SizedBox();
  }
}
