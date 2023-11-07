import 'package:fortune/domain/supabase/entity/mission/mission_clear_user_histories_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fortune_webview_state.freezed.dart';

@freezed
class FortuneWebviewState with _$FortuneWebviewState {
  factory FortuneWebviewState({
    required List<MissionClearUserHistoriesEntity> missions,
    required bool isLoading,
  }) = _FortuneWebviewState;

  factory FortuneWebviewState.initial() => FortuneWebviewState(
        missions: List.empty(),
        isLoading: true,
      );
}
