import 'package:foresh_flutter/domain/supabase/entity/mission_view_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'missions_state.freezed.dart';

@freezed
class MissionsState with _$MissionsState {
  factory MissionsState({
    required String nickname,
    required String profileImage,
    required List<MissionViewEntity> missions,
    required bool isLoading,
  }) = _MissionsState;

  factory MissionsState.initial() => MissionsState(
        nickname: "",
        profileImage: "",
        missions: List.empty(),
        isLoading: true,
      );
}