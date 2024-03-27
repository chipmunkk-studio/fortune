import 'package:fortune/domain/entity/mission_entity.dart';
import 'package:fortune/domain/entity/timestamps_entity.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_clear_user_histories_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'missions_state.freezed.dart';

@freezed
class MissionsState with _$MissionsState {
  factory MissionsState({
    required List<MissionEntity> missions,
    required TimestampsEntity timestamps,
    required bool isLoading,
  }) = _MissionsState;

  factory MissionsState.initial() => MissionsState(
        missions: List.empty(),
        timestamps: TimestampsEntity.initial(),
        isLoading: true,
      );
}
