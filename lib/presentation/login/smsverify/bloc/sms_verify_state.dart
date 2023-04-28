import 'package:freezed_annotation/freezed_annotation.dart';

part 'sms_verify_state.freezed.dart';

@freezed
class SmsVerifyState with _$SmsVerifyState {
  factory SmsVerifyState({
    required String phoneNumber,
    required String verifyCode,
    required String countryCode,
    required bool isEnabled,
  }) = _SmsVerifyState;

  factory SmsVerifyState.initial() => SmsVerifyState(
        verifyCode: "",
        phoneNumber: "",
        countryCode: "",
        isEnabled: false,
      );
}
