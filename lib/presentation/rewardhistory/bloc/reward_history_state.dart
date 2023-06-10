import 'package:foresh_flutter/domain/supabase/entity/reward_history_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reward_history_state.freezed.dart';

@freezed
class RewardHistoryState with _$RewardHistoryState {
  factory RewardHistoryState({
    required List<RewardHistoryEntity> histories,
  }) = _RewardHistoryState;

  factory RewardHistoryState.initial() => RewardHistoryState(
    histories: List.empty(),
  );
}
