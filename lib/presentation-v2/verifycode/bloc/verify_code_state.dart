import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_code_state.freezed.dart';

@freezed
class VerifyCodeState with _$VerifyCodeState {
  factory VerifyCodeState({
    required String email,
    required String verifyCode,
    required int verifyTime,
    required bool isLoginProcessing,
    required bool isConfirmEnable,
    required bool isRequestVerifyCodeEnable,
  }) = _VerifyCodeState;

  factory VerifyCodeState.initial([
    String? email,
  ]) =>
      VerifyCodeState(
        email: email ?? "",
        verifyCode: "",
        verifyTime: 180,
        isLoginProcessing: false,
        isConfirmEnable: false,
        isRequestVerifyCodeEnable: true,
      );
}
