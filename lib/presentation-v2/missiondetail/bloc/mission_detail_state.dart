import 'package:flutter/foundation.dart';
import 'package:fortune/domain/entity/mission_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission_detail_state.freezed.dart';

@freezed
class MissionDetailState with _$MissionDetailState {
  factory MissionDetailState({
    required MissionEntity entity,
    required int timestamp,
    required bool isLoading,
    required bool isEnableButton,
    required bool isRequestObtaining,
  }) = _MissionDetailState;

  factory MissionDetailState.initial() => MissionDetailState(
        entity: MissionEntity.empty(),
        timestamp: 0,
        isEnableButton: false,
        isRequestObtaining: false,
        isLoading: true,
      );
}
