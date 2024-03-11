import 'package:fortune/domain/supabase/entity/agree_terms_entity.dart';
import 'package:fortune/presentation-v2/verifycode/bloc/verify_code.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'web_verify_code_state.freezed.dart';

@freezed
class WebVerifyCodeState with _$WebVerifyCodeState {
  factory WebVerifyCodeState({
    required String email,
    required List<AgreeTermsEntity> agreeTerms,
    required String verifyCode,
    required int verifyTime,
    required bool isRequestVerifyCodeEnable,
    required bool isLoginProcessing,
    required bool isConfirmEnable,
    required bool isTestAccount,
    required bool isRetire,
  }) = _WebVerifyCodeState;

  factory WebVerifyCodeState.initial([
    List<AgreeTermsEntity>? agreeTerms,
    String? email,
  ]) =>
      WebVerifyCodeState(
        email: email ?? "",
        agreeTerms: agreeTerms ?? List.empty(),
        verifyCode: "",
        verifyTime: VerifyCodeBloc.verifyTime,
        isRequestVerifyCodeEnable: true,
        isLoginProcessing: false,
        isConfirmEnable: false,
        isTestAccount: false,
        isRetire: false,
      );
}
