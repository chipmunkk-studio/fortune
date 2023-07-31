import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  factory LoginState({
    required String phoneNumber,
    required String guideTitle,
    required bool isButtonEnabled,
    required LoginUserState loginUserState,
  }) = _LoginState;

  factory LoginState.initial([String? phoneNumber]) => LoginState(
        phoneNumber: "",
        isButtonEnabled: false,
        loginUserState: LoginUserState.none,
        guideTitle: 'loginGuideTitle.phoneNumber'.tr(),
      );
}

enum LoginUserState {
  needToLogin,
  none,
}

abstract class LoginGuideTitle {
  static String get phoneNumber => 'loginGuideTitle.phoneNumber'.tr();

  static String get signInWithOtp => 'loginGuideTitle.signInWithOtp'.tr();

  static String get signInWithOtpNewMember => 'loginGuideTitle.signInWithOtpNewMember'.tr();
}