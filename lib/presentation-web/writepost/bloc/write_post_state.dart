import 'package:freezed_annotation/freezed_annotation.dart';

part 'write_post_state.freezed.dart';

@freezed
class WritePostState with _$WritePostState {
  factory WritePostState({
    required String inputJson,
  }) = _WritePostState;

  factory WritePostState.initial() => WritePostState(
        inputJson: '',
      );
}
