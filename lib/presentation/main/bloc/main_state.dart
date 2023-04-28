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
    required int chargeTicketCnt,
    required int normalTicketCnt,
    required int roundTime,
    required bool isNewMarker,
  }) = _MainState;

  factory MainState.initial() => MainState(
        markers: List.empty(),
        notices: List.empty(),
        userId: -1,
        myLocation: null,
        profileImage: "",
        chargeTicketCnt: 0,
        normalTicketCnt: 0,
        roundTime: -1,
        isNewMarker: false,
      );
}
