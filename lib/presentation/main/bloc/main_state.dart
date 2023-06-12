import 'package:foresh_flutter/domain/supabase/entity/obtain_marker_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:location/location.dart';

import '../component/map/main_location_data.dart';

part 'main_state.freezed.dart';

@freezed
class MainState with _$MainState {
  factory MainState({
    required List<MainLocationData> markers,
    required List<ObtainHistoryEntity> histories,
    required LocationData? myLocation,
    required int userId,
    required String? profileImage,
    required int ticketCount,
    required int refreshTime,
    required int refreshCount,
    required double clickableRadiusLength,
    required double zoomThreshold,
  }) = _MainState;

  // 60/18, 120/17, 240/16, 480/15(2.4,-0.01), 960/14(2.4,-0.005)
  factory MainState.initial() => MainState(
        markers: List.empty(),
        histories: List.empty(),
        userId: -1,
        myLocation: null,
        profileImage: "",
        ticketCount: 0,
        refreshTime: 0,
        refreshCount: 0,
        clickableRadiusLength: 60,
        zoomThreshold: 18,
      );
}
