import 'package:foresh_flutter/domain/entities/mission/mission_card_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'missions_state.freezed.dart';

@freezed
class MissionsState with _$MissionsState {
  factory MissionsState({
    required String nickname,
    required String profileImage,
    required List<MissionCardEntity> missions,
    required bool isLoading,
    required TabMission currentTab,
  }) = _MissionsState;

  factory MissionsState.initial() => MissionsState(
        nickname: "",
        profileImage: "",
        missions: List.empty(),
        isLoading: true,
        currentTab: TabMission.round,
      );
}

enum TabMission {
  ordinary,
  round,
}
