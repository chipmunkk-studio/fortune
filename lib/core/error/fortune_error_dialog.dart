import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dartz/dartz.dart';
import 'package:fluro/src/fluro_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/login/bloc/login.dart';

import 'fortune_app_failures.dart';

class FortuneDialogService {
  bool _isDialogShowing = false;

  Future<void> showErrorDialog(
    BuildContext context,
    FortuneFailure error, {
    Function0? btnOkOnPress,
    bool needToFinish = true,
  }) async {

    if (_isDialogShowing) return;
    _isDialogShowing = true;

    final router = serviceLocator<FortuneRouter>().router;

    _fortuneDialog(
      context,
      error,
      btnOkOnPress ??
          () {
            if (error is AuthFailure) {
              _isDialogShowing = false;
              if (needToFinish) {
                router.navigateTo(
                  context,
                  "${Routes.loginRoute}/:${LoginUserState.needToLogin}",
                  clearStack: true,
                  replace: false,
                );
              }
            } else {
              _isDialogShowing = false;
              btnOkOnPress?.call();
            }
          },
      needToFinish,
    ).show();
  }

  AwesomeDialog _fortuneDialog(
    BuildContext context,
    FortuneFailure error,
    Function0<dynamic>? btnOkOnPress,
    bool needToFinish,
  ) {
    return AwesomeDialog(
      context: context,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                error.description ?? error.message ?? '알 수 없는 에러',
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
      btnOkOnPress: btnOkOnPress,
    );
  }
}
