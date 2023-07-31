import 'package:freezed_annotation/freezed_annotation.dart';

part 'alarm_feed_state.freezed.dart';

@freezed
class AlarmFeedState with _$AlarmFeedState {
  factory AlarmFeedState({
    required String phoneNumber,
  }) = _AlarmFeedState;

  factory AlarmFeedState.initial([
    String? phoneNumber,
  ]) =>
      AlarmFeedState(
        phoneNumber: phoneNumber ?? "",
      );
}
