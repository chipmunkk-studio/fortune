import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/obtain_history_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:location/location.dart';

import '../component/map/main_location_data.dart';

part 'main_state.freezed.dart';

@freezed
class MainState with _$MainState {
  factory MainState({
    required List<MainLocationData> markers,
    required List<ObtainHistoryContentViewItem> histories,
    required LocationData? myLocation,
    required FortuneUserEntity? user,
    required int haveCount,
    required int refreshTime,
    required int refreshCount,
    required bool isLoading,
    required double clickableRadiusLength,
    required double zoomThreshold,
  }) = _MainState;

  // 60/18, 120/17, 240/16, 480/15(2.4,-0.01), 960/14(2.4,-0.005)
  factory MainState.initial() => MainState(
        markers: List.empty(),
        histories: List.empty(),
        user: null,
        myLocation: null,
        haveCount: 0,
        refreshTime: 0,
        refreshCount: 0,
        isLoading: true,
        clickableRadiusLength: 60,
        zoomThreshold: 18,
      );
}
