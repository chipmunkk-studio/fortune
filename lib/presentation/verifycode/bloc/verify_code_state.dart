import 'package:fortune/domain/supabase/entity/agree_terms_entity.dart';
import 'package:fortune/domain/supabase/entity/country_info_entity.dart';
import 'package:fortune/presentation/login/bloc/login.dart';
import 'package:fortune/presentation/verifycode/bloc/verify_code_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_code_state.freezed.dart';

@freezed
class VerifyCodeState with _$VerifyCodeState {
  factory VerifyCodeState({
    required String phoneNumber,
    required List<AgreeTermsEntity> agreeTerms,
    required String verifyCode,
    required CountryInfoEntity countryInfoEntity,
    required LoginUserState loginUserState,
    required int verifyTime,
    required bool isRequestVerifyCodeEnable,
    required bool isLoginProcessing,
    required bool isConfirmEnable,
    required bool isTestAccount,
  }) = _VerifyCodeState;

  factory VerifyCodeState.initial([
    List<AgreeTermsEntity>? agreeTerms,
    String? phoneNumber,
  ]) =>
      VerifyCodeState(
        phoneNumber: phoneNumber ?? "",
        agreeTerms: agreeTerms ?? List.empty(),
        countryInfoEntity: CountryInfoEntity.empty(),
        verifyCode: "",
        verifyTime: VerifyCodeBloc.verifyTime,
        isRequestVerifyCodeEnable: true,
        loginUserState: LoginUserState.needToLogin,
        isLoginProcessing: false,
        isConfirmEnable: false,
        isTestAccount: false,
      );
}
