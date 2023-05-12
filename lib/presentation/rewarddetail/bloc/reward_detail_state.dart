import 'package:foresh_flutter/domain/entities/reward/reward_exchangeable_marker_entity.dart';
import 'package:foresh_flutter/domain/entities/reward/reward_notice_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reward_detail_state.freezed.dart';

@freezed
class RewardDetailState with _$RewardDetailState {
  factory RewardDetailState({
    required String rewardImage,
    required int rewardId,
    required String name,
    required List<RewardExchangeableMarkerEntity> haveMarkers,
    required List<RewardNoticeEntity> notices,
    required bool isLoading,
  }) = _RewardDetailState;

  factory RewardDetailState.initial() => RewardDetailState(
        rewardImage: "",
        name: "",
        rewardId: -1,
        haveMarkers: List.empty(),
        notices: List.empty(),
        isLoading: true,
      );
}
