
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/gen/fonts.gen.dart';

DefaultStyles buildDefaultStyles(
  DefaultTextStyle defaultTextStyle,
  TextStyle baseStyle,
  TextStyle inlineCodeStyle,
  VerticalSpacing baseSpacing,
) {
  return DefaultStyles(
    h1: DefaultTextBlockStyle(
      defaultTextStyle.style.copyWith(
        fontSize: 34,
        color: ColorName.white.withOpacity(0.70),
        height: 1.15,
        fontFamily: FontFamily.pretendardSemiBold,
        decoration: TextDecoration.none,
      ),
      const VerticalSpacing(16, 0),
      const VerticalSpacing(0, 0),
      null,
    ),
    h2: DefaultTextBlockStyle(
        defaultTextStyle.style.copyWith(
          fontSize: 24,
          color: ColorName.white.withOpacity(0.70),
          height: 1.15,
          fontFamily: FontFamily.pretendardSemiBold,
          fontWeight: FontWeight.normal,
          decoration: TextDecoration.none,
        ),
        const VerticalSpacing(8, 0),
        const VerticalSpacing(0, 0),
        null),
    h3: DefaultTextBlockStyle(
      defaultTextStyle.style.copyWith(
        fontSize: 20,
        color: ColorName.white.withOpacity(0.70),
        height: 1.25,
        fontFamily: FontFamily.pretendardSemiBold,
        decoration: TextDecoration.none,
      ),
      const VerticalSpacing(8, 0),
      const VerticalSpacing(0, 0),
      null,
    ),
    paragraph: DefaultTextBlockStyle(
      baseStyle.copyWith(color: Colors.white, fontFamily: FontFamily.pretendardRegular),
      const VerticalSpacing(0, 0),
      const VerticalSpacing(0, 0),
      null,
    ),
    bold: const TextStyle(
      fontFamily: FontFamily.pretendardBold,
    ),
    subscript: const TextStyle(
      fontFeatures: [
        FontFeature.subscripts(),
      ],
    ),
    superscript: const TextStyle(
      fontFeatures: [
        FontFeature.superscripts(),
      ],
    ),
    italic: const TextStyle(
      fontStyle: FontStyle.italic,
    ),
    small: const TextStyle(
      fontSize: 12,
      fontFamily: FontFamily.pretendardRegular,
    ),
    underline: const TextStyle(
      decoration: TextDecoration.underline,
      decorationColor: ColorName.white,
      fontFamily: FontFamily.pretendardRegular,
    ),
    strikeThrough: const TextStyle(
      decoration: TextDecoration.lineThrough,
      decorationColor: ColorName.white,
    ),
    inlineCode: InlineCodeStyle(
      backgroundColor: Colors.grey.shade100,
      radius: const Radius.circular(3),
      style: inlineCodeStyle,
      header1: inlineCodeStyle.copyWith(
        fontSize: 32,
        fontFamily: FontFamily.pretendardSemiBold,
        fontWeight: FontWeight.w300,
      ),
      header2: inlineCodeStyle.copyWith(
        fontSize: 22,
        fontFamily: FontFamily.pretendardSemiBold,
        fontWeight: FontWeight.normal,
      ),
      header3: inlineCodeStyle.copyWith(
        fontSize: 18,
        fontFamily: FontFamily.pretendardSemiBold,
        fontWeight: FontWeight.w500,
      ),
    ),
    link: const TextStyle(
        color: ColorName.primary, decoration: TextDecoration.underline, decorationColor: ColorName.primary),
    placeHolder: DefaultTextBlockStyle(
      defaultTextStyle.style.copyWith(
        fontSize: 16,
        height: 1.3,
        fontFamily: FontFamily.pretendardRegular,
        decoration: TextDecoration.none,
        color: Colors.grey.withOpacity(0.6),
      ),
      const VerticalSpacing(0, 0),
      const VerticalSpacing(0, 0),
      null,
    ),
    lists: DefaultListBlockStyle(
      baseStyle,
      baseSpacing,
      const VerticalSpacing(0, 6),
      null,
      null,
    ),
    quote: DefaultTextBlockStyle(
      const TextStyle(color: ColorName.white, fontFamily: FontFamily.pretendardRegular),
      baseSpacing,
      const VerticalSpacing(6, 2),
      BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 4,
            color: Colors.grey.shade300,
          ),
        ),
      ),
    ),
    code: DefaultTextBlockStyle(
      TextStyle(
        color: ColorName.grey800.withOpacity(0.9),
        fontFamily: FontFamily.pretendardRegular,
        fontSize: 16,
        height: 1.15,
      ),
      baseSpacing,
      const VerticalSpacing(0, 0),
      BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(2),
      ),
    ),
    indent: DefaultTextBlockStyle(
      baseStyle.copyWith(color: ColorName.white),
      baseSpacing,
      const VerticalSpacing(0, 6),
      null,
    ),
    align: DefaultTextBlockStyle(
      baseStyle.copyWith(color: ColorName.white),
      const VerticalSpacing(0, 0),
      const VerticalSpacing(0, 0),
      null,
    ),
    leading: DefaultTextBlockStyle(
      baseStyle,
      const VerticalSpacing(0, 0),
      const VerticalSpacing(0, 0),
      null,
    ),
    sizeSmall: const TextStyle(fontSize: 10, fontFamily: FontFamily.pretendardRegular),
    sizeLarge: const TextStyle(fontSize: 18, fontFamily: FontFamily.pretendardRegular),
    sizeHuge: const TextStyle(fontSize: 22, fontFamily: FontFamily.pretendardRegular),
  );
}
