import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/login/bloc/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'failure/auth_failure.dart';
import 'fortune_app_failures.dart';

class FortuneDialogService {
  bool _isDialogShowing = false;
  final supabaseClient = Supabase.instance.client;

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
              // 인증에러이지만, 로그인화면으로 보내면 안되는 경우가 있음.
              if (needToFinish) {
                supabaseClient.auth.signOut();
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
      dialogBackgroundColor: ColorName.grey800,
      buttonsTextStyle: FortuneTextStyle.button1Medium(fontColor: ColorName.grey800),
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      body: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  error.description ?? error.message ?? '알 수 없는 에러',
                  style: FortuneTextStyle.body1Light(fontColor: ColorName.grey200),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
      padding: const EdgeInsets.only(bottom: 10),
      dialogBorderRadius: BorderRadius.circular(
        32.r,
      ),
      btnOkColor: ColorName.primary,
      btnOkText: "확인",
      btnOkOnPress: btnOkOnPress,
    );
  }
}
