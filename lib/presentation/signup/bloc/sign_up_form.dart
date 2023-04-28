import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_form.freezed.dart';

part 'sign_up_form.g.dart';

@JsonSerializable(ignoreUnannotated: false)
@Freezed(toJson: true)
class SignUpForm with _$SignUpForm {
  factory SignUpForm({
    required String phoneNumber,
    required String countryCode,
    required String nickname,
  }) = _SignUpForm;

  factory SignUpForm.initial() => SignUpForm(
        phoneNumber: "",
        countryCode: "",
        nickname: "",
      );

}
