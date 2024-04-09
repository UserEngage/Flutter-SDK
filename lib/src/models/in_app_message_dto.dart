import 'dart:convert';

class InAppMessageDto {
  final int type;

  final ExitButtonDto exitButton;
  final BackgroundDto background;
  final String name;
  final List<InAppMessageItemDto> items;

  InAppMessageDto({
    required this.type,
    required this.exitButton,
    required this.background,
    required this.name,
    required this.items,
  });

  factory InAppMessageDto.fromMap(Map<String, dynamic> json) {
    return InAppMessageDto(
      type: json['type'] as int,
      exitButton: ExitButtonDto.fromJson(
        json['exit_button'] as Map<String, dynamic>,
      ),
      background: BackgroundDto.fromJson(
        json['background'] as Map<String, dynamic>,
      ),
      name: json['name'] as String,
      items: (json['items'] as List).map((item) {
        final itemType = item['type'];
        if (itemType == InAppItemTypeDto.button.value) {
          return InAppButtonDto.fromJson(item);
        } else if (itemType == InAppItemTypeDto.text.value) {
          return InAppMessageTextDto.fromJson(item);
        } else if (itemType == InAppItemTypeDto.image.value) {
          return InAppMessageImageDto.fromJson(item);
        } else {
          throw Exception('Unknown InAppItem type');
        }
      }).toList(),
    );
  }

  factory InAppMessageDto.fromJson(String source) =>
      InAppMessageDto.fromMap(json.decode(source) as Map<String, dynamic>);
}

enum InAppItemTypeDto {
  button(1),
  text(2),
  image(3);

  final int value;
  const InAppItemTypeDto(this.value);
}

class ExitButtonDto {
  final int horizontalMargin;
  final int? topMargin;
  final bool visible;
  final String color;

  final int alignment;

  ExitButtonDto({
    required this.horizontalMargin,
    required this.visible,
    required this.color,
    required this.topMargin,
    required this.alignment,
  });

  factory ExitButtonDto.fromJson(Map<String, dynamic> json) {
    return ExitButtonDto(
      horizontalMargin: json['horizontal_margin'] as int,
      visible: json['visible'] as bool,
      color: json['color'] as String,
      topMargin: json['top_margin'] as int?,
      alignment: json['alignment'] as int,
    );
  }
}

class BackgroundDto {
  final String color;
  final String url;

  BackgroundDto({
    required this.color,
    required this.url,
  });

  factory BackgroundDto.fromJson(Map<String, dynamic> json) {
    return BackgroundDto(
      color: json['color'] as String,
      url: json['url'] as String,
    );
  }
}

abstract class InAppMessageItemDto {}

class InAppButtonDto extends InAppMessageItemDto {
  final int type;

  final int rightMargin;
  final int botMargin;
  final int leftMargin;
  final int topMargin;

  final String color;

  final double fontSize;
  final List<int> format;
  final String text;
  final String textColor;
  final String fontFamily;

  final int alignment;
  final String link;
  final double radius;

  InAppButtonDto({
    required this.rightMargin,
    required this.fontSize,
    required this.format,
    required this.botMargin,
    required this.leftMargin,
    required this.color,
    required this.text,
    required this.textColor,
    required this.topMargin,
    required this.fontFamily,
    required this.type,
    required this.alignment,
    required this.link,
    required this.radius,
  });

  factory InAppButtonDto.fromJson(Map<String, dynamic> json) {
    return InAppButtonDto(
      rightMargin: json['right_margin'] as int,
      fontSize: json['font_size'].toDouble() as double,
      format: json['format'].cast<int>(),
      botMargin: json['bot_margin'] as int,
      leftMargin: json['left_margin'] as int,
      text: json['text'] as String,
      color: json['color'] as String,
      textColor: json['text_color'] as String,
      topMargin: json['top_margin'] as int,
      fontFamily: json['font_family'] as String,
      type: json['type'] as int,
      alignment: json['alignment'] as int,
      link: json['link'] as String,
      radius: json['radius'].toDouble() as double,
    );
  }
}

class InAppMessageTextDto extends InAppMessageItemDto {
  final int type;

  final int topMargin;
  final int botMargin;
  final int leftMargin;
  final int rightMargin;

  final String text;
  final List<int> format;
  final int alignment;
  final String fontFamily;
  final double fontSize;
  final String textColor;

  InAppMessageTextDto({
    required this.type,
    required this.text,
    required this.format,
    required this.alignment,
    required this.fontFamily,
    required this.fontSize,
    required this.textColor,
    required this.topMargin,
    required this.botMargin,
    required this.leftMargin,
    required this.rightMargin,
  });

  factory InAppMessageTextDto.fromJson(Map<String, dynamic> json) {
    return InAppMessageTextDto(
      type: json['type'] as int,
      text: json['text'] as String,
      format: json['format'].cast<int>(),
      alignment: json['alignment'] as int,
      fontFamily: json['font_family'] as String,
      fontSize: json['font_size'].toDouble() as double,
      textColor: json['text_color'] as String,
      topMargin: json['top_margin'] as int,
      botMargin: json['bot_margin'] as int,
      leftMargin: json['left_margin'] as int,
      rightMargin: json['right_margin'] as int,
    );
  }
}

class InAppMessageImageDto extends InAppMessageItemDto {
  final int type;

  final int topMargin;
  final int botMargin;
  final int leftMargin;
  final int rightMargin;

  final String url;

  InAppMessageImageDto({
    required this.type,
    required this.url,
    required this.topMargin,
    required this.botMargin,
    required this.leftMargin,
    required this.rightMargin,
  });

  factory InAppMessageImageDto.fromJson(Map<String, dynamic> json) {
    return InAppMessageImageDto(
      type: json['type'] as int,
      url: json['url'] as String,
      topMargin: json['top_margin'] as int,
      botMargin: json['bot_margin'] as int,
      leftMargin: json['left_margin'] as int,
      rightMargin: json['right_margin'] as int,
    );
  }
}
