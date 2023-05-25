import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';

import 'fortune_app_failures.dart';

extension FortuneContextEx on BuildContext {
  void handleError(
    FortuneFailure error, {
    Function0? btnOkOnPress,
    bool needToFinish = true,
  }) {
    final router = serviceLocator<FortuneRouter>().router;

    if (error is AuthFailure) {
      AwesomeDialog(
        context: this,
        animType: AnimType.scale,
        dialogType: DialogType.noHeader,
        dialogBackgroundColor: ColorName.backgroundLight,
        buttonsTextStyle: FortuneTextStyle.button1Medium(fontColor: ColorName.backgroundLight),
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        body: Container(
          color: ColorName.backgroundLight,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 32.h),
              Text("cert_expiration".tr(), style: FortuneTextStyle.subTitle1SemiBold(fontColor: ColorName.active)),
              SizedBox(height: 8.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  error.message ?? "No message",
                  style: FortuneTextStyle.body1Regular(fontColor: ColorName.activeDark),
                ),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
        padding: EdgeInsets.only(
          bottom: 10.h,
        ),
        dialogBorderRadius: BorderRadius.circular(
          32.r,
        ),
        btnOkColor: ColorName.primary,
        btnOkText: "확인",
        btnOkOnPress: btnOkOnPress ??
            () {
              final errorCode = error.errorCode;
              if ((errorCode == HttpStatus.unauthorized || errorCode == HttpStatus.forbidden) && needToFinish) {
                router.navigateTo(
                  this,
                  Routes.loginRoute,
                  clearStack: true,
                  replace: false,
                );
              }
            },
      ).show();
    } else {
      AwesomeDialog(
        context: this,
        animType: AnimType.scale,
        dialogType: DialogType.noHeader,
        dialogBackgroundColor: ColorName.backgroundLight,
        buttonsTextStyle: FortuneTextStyle.button1Medium(fontColor: ColorName.backgroundLight),
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: true,
        body: Container(
          color: ColorName.backgroundLight,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 32.h),
              Text(error.code.toString(), style: FortuneTextStyle.subTitle1SemiBold(fontColor: ColorName.active)),
              SizedBox(height: 8.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  error.message ?? 'No message',
                  style: FortuneTextStyle.body1Regular(fontColor: ColorName.activeDark),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
        padding: EdgeInsets.only(
          bottom: 10.h,
        ),
        dialogBorderRadius: BorderRadius.circular(
          32.r,
        ),
        btnOkColor: ColorName.primary,
        btnOkText: "확인",
        btnOkOnPress: btnOkOnPress ?? () {},
      ).show();
    }
  }
}
