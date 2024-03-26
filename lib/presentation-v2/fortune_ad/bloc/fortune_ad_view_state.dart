import 'package:fortune/presentation-v2/fortune_ad/admanager/fortune_ad.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fortune_ad_view_state.freezed.dart';

@freezed
class FortuneAdViewState with _$FortuneAdViewState {
  factory FortuneAdViewState({
    required int ts,
    required FortuneAdState? adState,
    required bool isCallAdFail,
    required bool isAdRequestError,
  }) = _FortuneAdViewState;

  factory FortuneAdViewState.initial() => FortuneAdViewState(
        ts: 0,
        adState: null,
        isCallAdFail: true,
        isAdRequestError: false,
      );
}