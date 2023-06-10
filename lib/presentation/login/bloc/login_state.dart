import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  factory LoginState({
    required String phoneNumber,
    required String verifyCode,
    required String guideTitle,
    required bool isRequestVerifyCodeEnable,
    required bool isButtonEnabled,
    required LoginUserState loginUserState,
    required int verifyTime,
    required List<LoginStepper> steppers,
  }) = _LoginState;

  factory LoginState.initial([String? phoneNumber]) => LoginState(
        phoneNumber: "",
        isButtonEnabled: true,
        verifyCode: "",
        verifyTime: 0,
        isRequestVerifyCodeEnable: true,
        loginUserState: LoginUserState.none,
        guideTitle: 'loginGuideTitle.phoneNumber'.tr(),
        steppers: [LoginStepper.phoneNumber],
      );
}

enum LoginStepper {
  phoneNumber,
  signInWithOtp,
}

enum LoginUserState {
  sessionExpired,
  needToLogin,
  none,
}

abstract class LoginGuideTitle {
  static String get phoneNumber => 'loginGuideTitle.phoneNumber'.tr();

  static String get signInWithOtp => 'loginGuideTitle.signInWithOtp'.tr();

  static String get signInWithOtpNewMember => 'loginGuideTitle.signInWithOtpNewMember'.tr();
}
