import 'package:foresh_flutter/domain/supabase/entity/agree_terms_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_code_state.freezed.dart';

@freezed
class VerifyCodeState with _$VerifyCodeState {
  factory VerifyCodeState({
    required String phoneNumber,
    required List<AgreeTermsEntity> agreeTerms,
    required String verifyCode,
    required int verifyTime,
    required bool isRequestVerifyCodeEnable,
  }) = _VerifyCodeState;

  factory VerifyCodeState.initial([
    List<AgreeTermsEntity>? agreeTerms,
    String? phoneNumber,
  ]) =>
      VerifyCodeState(
        phoneNumber: phoneNumber ?? "",
        agreeTerms: agreeTerms ?? List.empty(),
        verifyCode: "",
        verifyTime: 0,
        isRequestVerifyCodeEnable: true,
      );
}
