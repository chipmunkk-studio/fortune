import 'package:freezed_annotation/freezed_annotation.dart';

part 'web_retire_state.freezed.dart';

@freezed
class WebRetireState with _$WebRetireState {
  factory WebRetireState({
    required String email,
    required bool isButtonEnabled,
    required bool isLoading,
  }) = _WebRetireState;

  factory WebRetireState.initial([String? phoneNumber]) => WebRetireState(
        email: "",
        isButtonEnabled: false,
        isLoading: true,
      );
}
