import 'package:flutter/material.dart';

import 'package:flutter_user_sdk/flutter_user_sdk.dart';
import 'package:flutter_user_sdk/src/notifications/notification_adapter.dart';

class InAppMessageModel extends UserComMessage {
  final String id;
  final Alignment alignment;
  final bool isFullscreen;
  final String name;
  final NotificationType notificationType;
  final ExitButtonModel exitButton;
  final BackgroundModel background;
  final List<InAppMessageItemModel> items;

  InAppMessageModel({
    required this.id,
    required this.alignment,
    required this.isFullscreen,
    required this.exitButton,
    required this.background,
    required this.name,
    required this.items,
  }) : notificationType = NotificationType.inApp;
}

class ExitButtonModel {
  final EdgeInsets margin;
  final bool visible;
  final Color color;
  final Alignment alignment;

  ExitButtonModel({
    required this.margin,
    required this.visible,
    required this.color,
    required this.alignment,
  });
}

class BackgroundModel {
  final Color? color;
  final String imageUrl;

  bool get isValidUrl => imageUrl.isNotEmpty;

  BackgroundModel({
    this.color,
    required this.imageUrl,
  });
}

abstract class InAppMessageItemModel {}

class InAppButtonModel extends InAppMessageItemModel {
  final EdgeInsets margin;

  final String text;

  final TextStyle textStyle;

  final Alignment alignment;

  final double buttonRadius;

  final Color? buttonColor;

  final String link;

  InAppButtonModel({
    required this.margin,
    required this.text,
    required this.textStyle,
    required this.alignment,
    required this.buttonRadius,
    required this.link,
    this.buttonColor,
  });
}

class InAppMessageTextModel extends InAppMessageItemModel {
  final EdgeInsets margin;
  final String text;
  final TextStyle textStyle;
  final Alignment alignment;
  final TextAlign textAlignment;

  InAppMessageTextModel({
    required this.margin,
    required this.text,
    required this.textStyle,
    required this.alignment,
    required this.textAlignment,
  });
}

class InAppMessageImageModel extends InAppMessageItemModel {
  final EdgeInsets margin;

  final String url;

  bool get isUrlValid => url.isNotEmpty;

  InAppMessageImageModel({
    required this.margin,
    required this.url,
  });
}
