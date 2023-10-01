import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/gen/fonts.gen.dart';

abstract class FortuneTextStyle {
  static TextStyle headLine1({
    Color? fontColor,
  }) {
    return TextStyle(
      fontSize: 28.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: fontColor ?? ColorName.white,
    );
  }

  static TextStyle headLine2({Color? fontColor}) {
    return TextStyle(
      fontSize: 24.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: fontColor ?? ColorName.white,
    );
  }

  static TextStyle subTitle1Bold({Color? fontColor}) {
    return TextStyle(
      fontSize: 22.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardBold,
      color: fontColor ?? ColorName.white,
    );
  }

  static TextStyle subTitle1Medium({Color? fontColor}) {
    return TextStyle(
      fontSize: 22.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardMedium,
      color: fontColor ?? ColorName.white,
    );
  }

  static TextStyle subTitle2SemiBold({Color? fontColor}) {
    return TextStyle(
      fontSize: 20.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: fontColor ?? ColorName.white,
    );
  }

  static TextStyle subTitle2Medium({Color? fontColor}) {
    return TextStyle(
      fontSize: 20.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardMedium,
      color: fontColor ?? ColorName.white,
    );
  }

  static TextStyle body1Semibold({Color? fontColor}) {
    return TextStyle(
      fontSize: 18.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: fontColor ?? ColorName.white,
    );
  }

  static TextStyle body1Light({
    Color? color,
    double? height,
  }) {
    return TextStyle(
      fontSize: 18.spMin,
      height: height ?? 1.0,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardLight,
      color: color ?? ColorName.white,
    );
  }

  static TextStyle body2Semibold({Color? fontColor}) {
    return TextStyle(
      fontSize: 16.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: fontColor ?? ColorName.white,
    );
  }

  static TextStyle body2Light({Color? fontColor}) {
    return TextStyle(
      fontSize: 16.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardLight,
      color: fontColor ?? ColorName.white,
    );
  }

  static TextStyle body3Semibold({Color? fontColor}) {
    return TextStyle(
      fontSize: 15.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: fontColor ?? ColorName.white,
    );
  }

  static TextStyle body3Light({Color? color}) {
    return TextStyle(
      fontSize: 15.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardLight,
      color: color ?? ColorName.white,
    );
  }

  static TextStyle button1Medium({Color? fontColor}) {
    return TextStyle(
      fontSize: 18.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardMedium,
      color: fontColor ?? ColorName.white,
    );
  }

  static TextStyle caption1SemiBold({Color? fontColor}) {
    return TextStyle(
      fontSize: 14.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: fontColor ?? ColorName.white,
    );
  }

  static TextStyle caption2Regular({Color? fontColor}) {
    return TextStyle(
      fontSize: 14.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardRegular,
      color: fontColor ?? ColorName.white,
    );
  }

  static TextStyle caption3Semibold({Color? fontColor}) {
    return TextStyle(
      fontSize: 11.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: fontColor ?? ColorName.white,
    );
  }
}
