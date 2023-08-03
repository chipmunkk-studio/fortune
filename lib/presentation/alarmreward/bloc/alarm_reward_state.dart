import 'package:foresh_flutter/domain/supabase/entity/eventnotice/alarm_rewards_history_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'alarm_reward_state.freezed.dart';

@freezed
class AlarmRewardState with _$AlarmRewardState {
  factory AlarmRewardState({
    required AlarmRewardHistoryEntity reward,
  }) = _AlarmRewardState;

  factory AlarmRewardState.initial([
    AlarmRewardHistoryEntity? reward,
  ]) =>
      AlarmRewardState(
        reward: reward ?? AlarmRewardHistoryEntity.empty(),
      );
}
