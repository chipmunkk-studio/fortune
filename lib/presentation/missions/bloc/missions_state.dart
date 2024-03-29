import 'package:fortune/domain/supabase/entity/mission/mission_view_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

part 'missions_state.freezed.dart';

@freezed
class MissionsState with _$MissionsState {
  factory MissionsState({
    required String nickname,
    required String profileImage,
    required List<MissionViewEntity> missions,
    required BannerAd? ad,
    required bool isLoading,
  }) = _MissionsState;

  factory MissionsState.initial() => MissionsState(
        nickname: "",
        profileImage: "",
        missions: List.empty(),
        ad: null,
        isLoading: true,
      );
}
