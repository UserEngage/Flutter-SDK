import 'package:flutter/material.dart';
import 'package:flutter_user_sdk/src/models/in_app_message_model.dart';

class InAppText extends StatelessWidget {
  const InAppText({super.key, required this.model});
  final InAppMessageTextModel model;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: model.alignment,
      child: Padding(
        padding: model.margin,
        child: Text(
          model.text,
          style: model.textStyle,
          textAlign: model.textAlignment,
        ),
      ),
    );
  }
}
