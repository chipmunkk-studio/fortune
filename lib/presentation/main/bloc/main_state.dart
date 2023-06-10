import 'package:equatable/equatable.dart';
import 'package:foresh_flutter/domain/supabase/entity/reward_history_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:location/location.dart';

import '../component/map/main_location_data.dart';

part 'main_state.freezed.dart';

@freezed
class MainState with _$MainState {
  factory MainState({
    required List<MainLocationData> markers,
    required List<RewardHistoryEntity> notices,
    required LocationData? myLocation,
    required int userId,
    required String? profileImage,
    required int ticketCount,
    required RefreshTime refreshTime,
    required double clickableRadiusLength,
    required double zoomThreshold,
  }) = _MainState;

  factory MainState.initial() => MainState(
        markers: List.empty(),
        notices: List.empty(),
        userId: -1,
        myLocation: null,
        profileImage: "",
        ticketCount: 0,
        refreshTime: const RefreshTime(time: -1),
        // 60/18, 120/17, 240/16, 480/15(2.4,-0.01), 960/14(2.4,-0.005)
        clickableRadiusLength: 60,
        zoomThreshold: 18,
      );
}

class RefreshTime extends Equatable {
  final int time;
  final int count;

  const RefreshTime({
    required this.time,
    this.count = 0,
  });

  RefreshTime copyWith({
    int? time,
    int? count,
  }) =>
      RefreshTime(
        time: time ?? this.time,
        count: count ?? this.count,
      );

  @override
  List<Object?> get props => [count, time];
}
