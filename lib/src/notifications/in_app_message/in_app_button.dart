import 'package:flutter/material.dart';
import 'package:flutter_user_sdk/src/models/in_app_message_model.dart';

class InAppButton extends StatelessWidget {
  const InAppButton({
    super.key,
    required this.model,
    required this.onTap,
  });

  final InAppButtonModel model;
  final Function(String url) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: model.margin,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: model.buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(model.buttonRadius),
            ),
          ),
          onPressed: () {
            onTap(model.link);
          },
          child: Text(
            model.text,
            style: model.textStyle,
          ),
        ),
      ),
    );
  }
}
