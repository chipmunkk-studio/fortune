import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission_detail_state.freezed.dart';

@freezed
class MissionDetailState with _$MissionDetailState {
  factory MissionDetailState({
    required String rewardImage,
    required int missionId,
    required String name,
    required bool isLoading,
  }) = _MissionDetailState;

  factory MissionDetailState.initial() => MissionDetailState(
        rewardImage: "",
        name: "",
        missionId: -1,
        isLoading: true,
      );
}
