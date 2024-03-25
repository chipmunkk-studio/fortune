import 'package:fortune/core/fortune_ext.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/domain/entity/fortune_user_entity.dart';
import 'package:fortune/domain/entity/marker_entity.dart';
import 'package:fortune/domain/entity/marker_list_entity.dart';
import 'package:fortune/presentation-v2/admanager/fortune_ad.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:latlong2/latlong.dart';

part 'main_state.freezed.dart';

@freezed
class MainState with _$MainState {
  factory MainState({
    required LatLng currentLocation,
    required LatLng cameraLocation,
    required List<MarkerEntity> markerList,
    required FortuneUserEntity user,
    required String locationName,
    required FortuneAdState? ad,
    required double prevHeadings,
    required double turns,
    required double zoomThreshold,
    required bool isLoading,
    required bool isTestDeviceMode,
  }) = _MainState;

  // 60/18, 120/17, 240/16, 480/15(2.4,-0.01), 960/14(2.4,-0.005)
  factory MainState.initial() => MainState(
        currentLocation: const LatLng(0.0, 0.0),
        cameraLocation: const LatLng(0.0, 0.0),
        user: FortuneUserEntity.empty(),
        ad: null,
        prevHeadings: 0,
        turns: 0,
        zoomThreshold: 19,
        locationName: FortuneTr.msgUnknownLocation,
        markerList: List.empty(),
        isLoading: true,
        isTestDeviceMode: true,
      );
}
