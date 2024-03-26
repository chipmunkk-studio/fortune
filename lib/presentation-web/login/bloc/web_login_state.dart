import 'package:freezed_annotation/freezed_annotation.dart';

part 'web_login_state.freezed.dart';

@freezed
class WebLoginState with _$WebLoginState {
  factory WebLoginState({
    required String email,
    required bool isButtonEnabled,
    required bool isLoading,
  }) = _WebLoginState;

  factory WebLoginState.initial([String? phoneNumber]) => WebLoginState(
        email: "",
        isButtonEnabled: false,
        isLoading: true,
      );
}
