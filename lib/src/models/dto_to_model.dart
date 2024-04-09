import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_user_sdk/src/models/in_app_message_dto.dart';
import 'package:flutter_user_sdk/src/models/in_app_message_model.dart';
import 'package:google_fonts/google_fonts.dart';

InAppMessageModel inAppMessageDtoToModel(
  String messageId,
  InAppMessageDto dto,
) {
  return InAppMessageModel(
    id: messageId,
    alignment: _getDialogAlignment(dto),
    isFullscreen: _getIsFullscreen(dto),
    exitButton: _getExitButtonFromDto(dto.exitButton),
    background: _getBackgroundFromDto(dto.background),
    name: dto.name,
    items: _itemsDtoToModel(dto.items),
  );
}

List<InAppMessageItemModel> _itemsDtoToModel(
  List<InAppMessageItemDto> dtoList,
) {
  return dtoList.map((item) {
    if (item is InAppButtonDto) {
      return _getInAppButton(item);
    } else if (item is InAppMessageTextDto) {
      return _getInAppText(item);
    } else if (item is InAppMessageImageDto) {
      return _getInAppImage(item);
    } else {
      throw Exception('Item not recognized');
    }
  }).toList();
}

InAppButtonModel _getInAppButton(InAppButtonDto dto) {
  return InAppButtonModel(
    margin: EdgeInsets.fromLTRB(
      dto.leftMargin.toDouble(),
      dto.topMargin.toDouble(),
      dto.rightMargin.toDouble(),
      dto.botMargin.toDouble(),
    ),
    buttonColor:
        dto.color.isNotEmpty ? _getColorFromHexString(dto.color) : null,
    text: dto.text,
    textStyle: _getTextStyleFromDto(
      fontSize: dto.fontSize,
      format: dto.format,
      textColor: dto.textColor,
      fontFamily: dto.fontFamily,
    ),
    alignment: _getAlignmentFromCode(dto.alignment),
    buttonRadius: dto.radius,
    link: dto.link,
  );
}

InAppMessageTextModel _getInAppText(InAppMessageTextDto dto) {
  return InAppMessageTextModel(
    margin: EdgeInsets.fromLTRB(
      dto.leftMargin.toDouble(),
      dto.topMargin.toDouble(),
      dto.rightMargin.toDouble(),
      dto.botMargin.toDouble(),
    ),
    text: dto.text,
    textStyle: _getTextStyleFromDto(
      fontSize: dto.fontSize,
      format: dto.format,
      textColor: dto.textColor,
      fontFamily: dto.fontFamily,
    ),
    alignment: _getAlignmentFromCode(dto.alignment),
    textAlignment: _getTextAlignmentFromCode(dto.alignment),
  );
}

InAppMessageImageModel _getInAppImage(InAppMessageImageDto dto) {
  return InAppMessageImageModel(
    margin: EdgeInsets.fromLTRB(
      dto.leftMargin.toDouble(),
      dto.topMargin.toDouble(),
      dto.rightMargin.toDouble(),
      dto.botMargin.toDouble(),
    ),
    url: dto.url,
  );
}

TextStyle _getTextStyleFromDto({
  required double fontSize,
  List<int> format = const [1],
  String? textColor,
  String fontFamily = 'Roboto',
}) {
  if (fontFamily.isEmpty) fontFamily = 'Roboto';
  try {
    return GoogleFonts.getFont(
      fontFamily,
      color: textColor != null ? _getColorFromHexString(textColor) : null,
      fontSize: fontSize,
      fontWeight: format.contains(2) ? FontWeight.w700 : FontWeight.w400,
      decoration:
          format.contains(4) ? TextDecoration.underline : TextDecoration.none,
      fontStyle: format.contains(3) ? FontStyle.italic : FontStyle.normal,
    );
  } catch (_) {
    return TextStyle(
      color: textColor != null ? _getColorFromHexString(textColor) : null,
      fontSize: fontSize,
      fontWeight: format.contains(2) ? FontWeight.w700 : FontWeight.w400,
      decoration:
          format.contains(4) ? TextDecoration.underline : TextDecoration.none,
      fontStyle: format.contains(3) ? FontStyle.italic : FontStyle.normal,
    );
  }
}

Alignment _getDialogAlignment(InAppMessageDto dto) {
  if (dto.type == 1) {
    return Alignment.topCenter;
  } else if (dto.type == 2) {
    return Alignment.center;
  } else if (dto.type == 3) {
    return Alignment.bottomCenter;
  } else if (dto.type == 4) {
    return Alignment.center;
  }
  {
    log('Cannot find alignment parameter in message. Alignment set to center');
    return Alignment.center;
  }
}

bool _getIsFullscreen(InAppMessageDto dto) {
  return dto.type == 4;
}

ExitButtonModel _getExitButtonFromDto(ExitButtonDto dto) {
  return ExitButtonModel(
    margin: EdgeInsets.fromLTRB(
      dto.horizontalMargin.toDouble(),
      (dto.topMargin ?? 0).toDouble(),
      dto.horizontalMargin.toDouble(),
      0,
    ),
    visible: dto.visible,
    color: _getColorFromHexString(dto.color),
    alignment: _getAlignmentFromCode(dto.alignment),
  );
}

BackgroundModel _getBackgroundFromDto(BackgroundDto dto) {
  return BackgroundModel(
    color: dto.color.isEmpty ? null : _getColorFromHexString(dto.color),
    imageUrl: dto.url,
  );
}

Alignment _getAlignmentFromCode(int code) {
  if (code == 1) {
    return Alignment.centerLeft;
  } else if (code == 2) {
    return Alignment.centerRight;
  } else if (code == 3) {
    return Alignment.center;
  } else {
    log('Cannot find alignment parameter. Setting to center');
    return Alignment.center;
  }
}

TextAlign _getTextAlignmentFromCode(int code) {
  if (code == 1) {
    return TextAlign.left;
  } else if (code == 2) {
    return TextAlign.right;
  } else if (code == 3) {
    return TextAlign.center;
  } else {
    log('Cannot find alignment parameter. Setting to center');
    return TextAlign.center;
  }
}

Color _getColorFromHexString(String hexColor) {
  final color = hexColor.replaceAll('#', '0xff');
  return Color(int.parse(color));
}
