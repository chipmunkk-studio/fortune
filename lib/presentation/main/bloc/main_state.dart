import 'package:foresh_flutter/domain/entities/main_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:location/location.dart';

import '../component/map/main_location_data.dart';

part 'main_state.freezed.dart';

@freezed
class MainState with _$MainState {
  factory MainState({
    required List<MainLocationData> markers,
    required List<MainHistoryEntity> notices,
    required LocationData? myLocation,
    required int userId,
    required String? profileImage,
    required int coinCount,
    required int ticketCount,
    required int roundTime,
    required double clickableRadiusLength,
    required double zoomThreshold,
  }) = _MainState;

  factory MainState.initial() => MainState(
        markers: List.empty(),
        notices: List.empty(),
        userId: -1,
        myLocation: null,
        profileImage: "",
        coinCount: 0,
        ticketCount: 0,
        roundTime: -1,
        // 60/18, 120/17, 240/16, 480/15(2.4,-0.01), 960/14(2.4,-0.005)
        clickableRadiusLength: 240,
        zoomThreshold: 16,
      );
}
