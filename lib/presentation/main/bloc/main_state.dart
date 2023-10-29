import 'package:fortune/core/message_ext.dart';
import 'package:fortune/domain/supabase/entity/eventnotice/alarm_feeds_entity.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_clear_user_histories_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../component/map/main_location_data.dart';

part 'main_state.freezed.dart';

@freezed
class MainState with _$MainState {
  factory MainState({
    required List<MainLocationData> markers,
    required List<MissionClearUserHistoriesEntity> missionClearUsers,
    required Position? myLocation,
    required FortuneUserEntity? user,
    required MainLocationData? processingMarker,
    required List<AlarmFeedsEntity> notices,
    required int haveCount,
    required bool isObtainProcessing,
    required bool hasNewAlarm,
    required RewardedAd? rewardAd,
    required String locationName,
    required bool isLoading,
    required double clickableRadiusLength,
    required double zoomThreshold,
    required double headings,
    required bool isRotatable,
    required bool isShowTestLocation,
  }) = _MainState;

  // 60/18, 120/17, 240/16, 480/15(2.4,-0.01), 960/14(2.4,-0.005)
  factory MainState.initial() =>
      MainState(
        markers: List.empty(),
        missionClearUsers: List.empty(),
        locationName: FortuneTr.msgUnknownLocation,
        user: null,
        myLocation: null,
        processingMarker: null,
        notices: List.empty(),
        haveCount: 0,
        isObtainProcessing: false,
        hasNewAlarm: false,
        isLoading: true,
        isRotatable: false,
        rewardAd: null,
        headings: 0,
        isShowTestLocation: false,
        clickableRadiusLength: 60,
        zoomThreshold: 18,
      );
}

