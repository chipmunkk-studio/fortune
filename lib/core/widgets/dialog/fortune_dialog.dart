import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/error/failure/auth_failure.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/di.dart';
import 'package:fortune/presentation/fortune_router.dart';
import 'package:fortune/presentation/login/bloc/login.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

    _fortuneErrorDialog(
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

  AwesomeDialog _fortuneErrorDialog(
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
                  style: FortuneTextStyle.body1Light(color: ColorName.grey200),
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

  void showFortuneDialog(
    BuildContext context, {
    String? title,
    String? subTitle,
    String? btnOkText,
    Function0? btnOkPressed,
    Function0? btnCancelPressed,
    Function1<DismissType, void>? onDismissCallback,
    String? btnCancelText,
    Color? btnOkColor,
    Color? btnCancelColor,
    Color? btnTextColor,
    dismissOnTouchOutside = false,
    dismissOnBackKeyPress = false,
  }) {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.noHeader,
      dialogBackgroundColor: ColorName.grey800,
      buttonsTextStyle: FortuneTextStyle.button1Medium(fontColor: btnTextColor ?? ColorName.grey900),
      dismissOnTouchOutside: dismissOnTouchOutside,
      dismissOnBackKeyPress: dismissOnBackKeyPress,
      body: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 타이틀이 있을 경우.
                if (title != null)
                  const SizedBox(height: 20)
                // 타이틀이 없고, 서브타이틀만 있을 경우.
                else if (subTitle != null)
                  const SizedBox(height: 3),
                if (title != null)
                  Text(
                    title,
                    style: FortuneTextStyle.headLine2(),
                    textAlign: TextAlign.center,
                  ),
                if (subTitle != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    subTitle,
                    style: FortuneTextStyle.body1Light(color: ColorName.grey200),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
      padding: const EdgeInsets.only(bottom: 10),
      dialogBorderRadius: BorderRadius.circular(32.r),
      btnOkColor: btnOkColor ?? ColorName.primary,
      btnOkText: btnOkText ?? FortuneTr.confirm,
      btnOkOnPress: btnOkPressed,
      btnCancelOnPress: btnCancelPressed,
      btnCancelColor: btnCancelColor ?? ColorName.grey500,
      btnCancelText: btnCancelText ?? FortuneTr.cancel,
      onDismissCallback: onDismissCallback,
    ).show();
  }

  void showFortuneMaterialDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String buttonText,
    required Function0 onPressed,
    LottieBuilder? lottieBuilder,
  }) =>
      Dialogs.materialDialog(
        color: Colors.white,
        msg: message,
        title: title,
        barrierDismissible: false,
        lottieBuilder: lottieBuilder,
        barrierColor: Colors.black12.withOpacity(0.6),
        // Background color
        dialogWidth: kIsWeb ? 0.3 : null,
        context: context,
        actions: [
          SizedBox(
            height: 46,
            child: IconsButton(
              onPressed: onPressed,
              text: buttonText,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: Colors.transparent,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              color: Colors.amberAccent,
              textStyle: const TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
          ),
        ],
      );
}
