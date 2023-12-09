import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/gen/fonts.gen.dart';

abstract class FortuneTextStyle {
  static TextStyle headLine1({
    Color? fontColor,
    double height = 1.0,
  }) {
    return TextStyle(
      fontSize: 28.spMin,
      letterSpacing: -0.06,
      height: height,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: fontColor ?? ColorName.white,
    );
  }

  static TextStyle headLine2({
    Color? fontColor,
    bool isSpMax = false,
  }) {
    return TextStyle(
      fontSize: isSpMax ? 24.spMax : 24.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: fontColor ?? ColorName.white,
    );
  }

  static TextStyle headLine3({
    Color? fontColor,
    bool isSpMax = false,
  }) {
    return TextStyle(
      fontSize: isSpMax ? 20.spMax : 20.spMin,
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

  static TextStyle subTitle1Medium({Color? color}) {
    return TextStyle(
      fontSize: 22.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardMedium,
      color: color ?? ColorName.white,
    );
  }

  static TextStyle subTitle2SemiBold({Color? color}) {
    return TextStyle(
      fontSize: 20.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: color ?? ColorName.white,
    );
  }

  static TextStyle subTitle2Medium({Color? color}) {
    return TextStyle(
      fontSize: 20.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardMedium,
      color: color ?? ColorName.white,
    );
  }

  static TextStyle body1Semibold({
    Color? color,
    double height = 1.0,
  }) {
    return TextStyle(
      fontSize: 18.spMin,
      height: height,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: color ?? ColorName.white,
    );
  }

  static TextStyle body1Regular({
    Color? color,
    double height = 1.0,
  }) {
    return TextStyle(
      fontSize: 18.spMin,
      height: height,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardRegular,
      color: color ?? ColorName.white,
    );
  }

  static TextStyle body2Semibold({
    Color? color,
    double height = 1.0,
  }) {
    return TextStyle(
      fontSize: 16.spMin,
      height: height,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: color ?? ColorName.white,
    );
  }

  static TextStyle body2Regular({
    Color? color,
    double height = 1.0,
  }) {
    return TextStyle(
      fontSize: 16.spMin,
      letterSpacing: -0.06,
      height: height,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardRegular,
      color: color ?? ColorName.white,
    );
  }

  static TextStyle body3Semibold({Color? color}) {
    return TextStyle(
      fontSize: 15.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: color ?? ColorName.white,
    );
  }

  static TextStyle body3Regular({
    Color? color,
    double height = 1.0,
  }) {
    return TextStyle(
      fontSize: 15.spMin,
      height: height,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardRegular,
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

  static TextStyle caption1SemiBold({
    Color? color,
    double height = 1.0,
    bool isSpMax = false,
  }) {
    return TextStyle(
      fontSize: isSpMax ? 14.spMax : 14.spMin,
      height: height,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: color ?? ColorName.white,
    );
  }

  static TextStyle caption2Regular({Color? color}) {
    return TextStyle(
      fontSize: 14.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardRegular,
      color: color ?? ColorName.white,
    );
  }

  static TextStyle caption3Semibold({Color? color}) {
    return TextStyle(
      fontSize: 11.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: color ?? ColorName.white,
    );
  }
}
