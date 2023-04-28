import 'package:foresh_flutter/presentation/signup/bloc/sign_up_form.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_state.freezed.dart';

@freezed
class SignUpState with _$SignUpState {
  factory SignUpState({
    required SignUpForm signUpForm,
    required String? profileImage,
  }) = _SignUpState;

  factory SignUpState.initial() => SignUpState(
        signUpForm: SignUpForm.initial(),
        profileImage: null,
      );
}
