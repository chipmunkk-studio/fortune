import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/gen/fonts.gen.dart';

abstract class FortuneTextStyle {
  static TextStyle body1Medium({Color? fontColor}) {
    return TextStyle(
      fontSize: 18.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardMedium,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle body1Regular({Color? fontColor}) {
    return TextStyle(
      fontSize: 18.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardRegular,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle body1SemiBold({Color? fontColor}) {
    return TextStyle(
      fontSize: 18.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle body2Regular({Color? fontColor}) {
    return TextStyle(
      fontSize: 16.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardRegular,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle body2SemiBold({Color? fontColor}) {
    return TextStyle(
      fontSize: 16.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle body3Bold({Color? fontColor}) {
    return TextStyle(
      fontSize: 15.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardBold,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle body3Regular({Color? fontColor}) {
    return TextStyle(
      fontSize: 15.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardRegular,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle button1Medium({Color? fontColor}) {
    return TextStyle(
      fontSize: 18.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardMedium,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle caption1SemiBold({Color? fontColor}) {
    return TextStyle(
      fontSize: 11.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle headLine1({Color? fontColor}) {
    return TextStyle(
      fontSize: 36.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle headLine2({Color? fontColor}) {
    return TextStyle(
      fontSize: 30.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle headLine3({
    Color? fontColor,
  }) {
    return TextStyle(
      fontSize: 28.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle subTitle1SemiBold({Color? fontColor}) {
    return TextStyle(
      fontSize: 24.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle subTitle1Regular({Color? fontColor}) {
    return TextStyle(
      fontSize: 24.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardRegular,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle subTitle2Medium({Color? fontColor}) {
    return TextStyle(
      fontSize: 22.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardMedium,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle subTitle2Bold({Color? fontColor}) {
    return TextStyle(
      fontSize: 20.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle subTitle3SemiBold({Color? fontColor}) {
    return TextStyle(
      fontSize: 20.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle subTitle3Medium({Color? fontColor}) {
    return TextStyle(
      fontSize: 20.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardMedium,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle subTitle3Regular({Color? fontColor}) {
    return TextStyle(
      fontSize: 20.spMin,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardRegular,
      color: fontColor ?? ColorName.active,
    );
  }
}
