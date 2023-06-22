import 'package:foresh_flutter/domain/supabase/entity/mission_detail_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission_detail_relay_state.freezed.dart';

@freezed
class MissionDetailRelayState with _$MissionDetailRelayState {
  factory MissionDetailRelayState({
    required MissionDetailEntity entity,
    required bool isLoading,
    required bool isEnableButton,
  }) = _MissionDetailRelayState;

  factory MissionDetailRelayState.initial() => MissionDetailRelayState(
        entity: MissionDetailEntity.initial(),
        isEnableButton: false,
        isLoading: true,
      );
}
