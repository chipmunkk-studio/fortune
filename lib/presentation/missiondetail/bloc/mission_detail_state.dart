import 'package:flutter/foundation.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission/mission_detail_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission_detail_state.freezed.dart';

@freezed
class MissionDetailState with _$MissionDetailState {
  factory MissionDetailState({
    required MissionDetailEntity entity,
    required Uint8List? confettiImage,
    required bool isLoading,
    required bool isEnableButton,
    required bool isRequestObtaining,
  }) = _MissionDetailState;

  factory MissionDetailState.initial() => MissionDetailState(
        entity: MissionDetailEntity.initial(),
        isEnableButton: false,
        isRequestObtaining: false,
        confettiImage: null,
        isLoading: true,
      );
}
