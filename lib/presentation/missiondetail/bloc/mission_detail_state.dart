import 'package:flutter/foundation.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_detail_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:ui' as ui;

part 'mission_detail_state.freezed.dart';

@freezed
class MissionDetailState with _$MissionDetailState {
  factory MissionDetailState({
    required MissionDetailEntity entity,
    required bool isLoading,
    required bool isEnableButton,
    required bool isRequestObtaining,
    required bool isFortuneCookieOpen,
  }) = _MissionDetailState;

  factory MissionDetailState.initial() => MissionDetailState(
        entity: MissionDetailEntity.initial(),
        isEnableButton: false,
        isRequestObtaining: false,
        isFortuneCookieOpen: false,
        isLoading: true,
      );
}
