import 'package:foresh_flutter/domain/entities/reward/reward_marker_entity.dart';
import 'package:foresh_flutter/domain/entities/reward/reward_product_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reward_list_state.freezed.dart';

@freezed
class RewardListState with _$RewardListState {
  factory RewardListState({
    required int totalMarkerCount,
    required List<RewardMarkerEntity> markers,
    required List<RewardProductPagingEntity> rewards,
    required bool isChangeableChecked,
    required bool isLoading,
    required int page,
    required bool isNextPageLoading,
  }) = _RewardListState;

  factory RewardListState.initial() => RewardListState(
        totalMarkerCount: 0,
        markers: List.empty(),
        rewards: List.empty(),
        page: 0,
        isNextPageLoading: false,
        isLoading: true,
        isChangeableChecked: false,
      );
}
