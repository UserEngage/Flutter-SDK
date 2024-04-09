import 'package:flutter/material.dart';
import 'package:flutter_user_sdk/src/models/in_app_message_model.dart';

class InAppImage extends StatelessWidget {
  const InAppImage({super.key, required this.model});
  final InAppMessageImageModel model;

  @override
  Widget build(BuildContext context) {
    return model.isUrlValid
        ? Padding(
            padding: model.margin,
            child: Image.network(model.url),
          )
        : const SizedBox();
  }
}
