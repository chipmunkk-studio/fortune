import 'package:foresh_flutter/domain/supabase/entity/normal_mission_detail_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission_detail_normal_state.freezed.dart';

@freezed
class MissionDetailNormalState with _$MissionDetailNormalState {
  factory MissionDetailNormalState({
    required NormalMissionDetailEntity entity,
    required bool isLoading,
    required bool isEnableButton,
  }) = _MissionDetailNormalState ;

  factory MissionDetailNormalState.initial() => MissionDetailNormalState(
        entity: NormalMissionDetailEntity.initial(),
        isEnableButton: false,
        isLoading: true,
      );
}
