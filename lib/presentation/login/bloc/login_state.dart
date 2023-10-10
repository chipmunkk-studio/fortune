import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:fortune/domain/supabase/entity/country_info_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  factory LoginState({
    required String email,
    required String guideTitle,
    required CountryInfoEntity selectCountry,
    required bool isButtonEnabled,
    required bool isLoading,
    required LoginUserState loginUserState,
  }) = _LoginState;

  factory LoginState.initial([String? phoneNumber]) => LoginState(
        email: "",
        isButtonEnabled: false,
        isLoading: true,
        selectCountry: CountryInfoEntity.empty(),
        loginUserState: LoginUserState.none,
        guideTitle: 'loginGuideTitle.phoneNumber'.tr(),
      );
}

enum LoginUserState {
  needToLogin,
  web,
  none,
}

abstract class LoginGuideTitle {
  static String get phoneNumber => 'loginGuideTitle.phoneNumber'.tr();

  static String get signInWithOtp => 'loginGuideTitle.signInWithOtp'.tr();

  static String get signInWithOtpNewMember => 'loginGuideTitle.signInWithOtpNewMember'.tr();
}
