import 'package:fortune/domain/supabase/entity/agree_terms_entity.dart';
import 'package:fortune/presentation/verifycode/bloc/verify_code_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'web_verify_code_state.freezed.dart';

@freezed
class WebVerifyCodeState with _$WebVerifyCodeState {
  factory WebVerifyCodeState({
    required String phoneNumber,
    required List<AgreeTermsEntity> agreeTerms,
    required String verifyCode,
    required int verifyTime,
    required bool isRequestVerifyCodeEnable,
    required bool isLoginProcessing,
    required bool isConfirmEnable,
    required bool isTestAccount,
  }) = _WebVerifyCodeState;

  factory WebVerifyCodeState.initial([
    List<AgreeTermsEntity>? agreeTerms,
    String? phoneNumber,
  ]) =>
      WebVerifyCodeState(
        phoneNumber: phoneNumber ?? "",
        agreeTerms: agreeTerms ?? List.empty(),
        verifyCode: "",
        verifyTime: VerifyCodeBloc.verifyTime,
        isRequestVerifyCodeEnable: true,
        isLoginProcessing: false,
        isConfirmEnable: false,
        isTestAccount: false,
      );
}
