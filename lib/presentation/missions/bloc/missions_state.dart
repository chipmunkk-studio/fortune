import 'package:foresh_flutter/domain/supabase/entity/normal_mission_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'missions_state.freezed.dart';

@freezed
class MissionsState with _$MissionsState {
  factory MissionsState({
    required String nickname,
    required String profileImage,
    required List<MissionsViewItem> missions,
    required bool isLoading,
  }) = _MissionsState;

  factory MissionsState.initial() => MissionsState(
        nickname: "",
        profileImage: "",
        missions: List.empty(),
        isLoading: true,
      );
}

abstract class MissionsViewItem {}

class MissionNormalViewItem extends MissionsViewItem {
  final MissionNormalEntity mission;
  final int userHaveCount;
  final int requiredTotalCount;

  MissionNormalViewItem({
    required this.mission,
    required this.userHaveCount,
    required this.requiredTotalCount,
  });
}
