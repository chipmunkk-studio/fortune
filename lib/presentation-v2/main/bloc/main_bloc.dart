import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/fortune_ext.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/core/util/mixpanel.dart';
import 'package:fortune/core/util/permission.dart';
import 'package:fortune/data/remote/response/fortune_response_ext.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/domain/entity/marker_entity.dart';
import 'package:fortune/domain/usecase/marker_list_use_case.dart';
import 'package:fortune/domain/usecase/user_me_use_case.dart';
import 'package:fortune/env.dart';
import 'package:fortune/presentation-v2/fortune_ad/admanager/fortune_ad.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'main.dart';

class MainBloc extends Bloc<MainEvent, MainState> with SideEffectBlocMixin<MainEvent, MainState, MainSideEffect> {
  final Environment environment;
  final MixpanelTracker tracker;
  final UserMeUseCase userMeUseCase;
  final MarkerListUseCase markerListUseCase;
  final FortuneAdManager adManager;

  MainBloc({
    required this.environment,
    required this.tracker,
    required this.userMeUseCase,
    required this.markerListUseCase,
    required this.adManager,
  }) : super(MainState.initial()) {
    on<MainInit>(
      _init,
      transformer: throttle(const Duration(seconds: 3)),
    );
    on<MainInitMyLocation>(
      _initMyLocation,
    );
    on<MainMarkerList>(
      _markerList,
      transformer: sequential(),
    );
    on<MainLocationChange>(
      _locationChange,
      transformer: sequential(),
    );
    on<MainCompassRotate>(
      _rotate,
      transformer: sequential(),
    );
    on<MainMarkerClick>(
      _markerClick,
      transformer: sequential(),
    );
    on<MainOnAdShowComplete>(
      _onAdShowComplete,
      transformer: sequential(),
    );
    on<MainObtainSuccess>(
      _obtainSuccess,
      transformer: sequential(),
    );
    on<MainOnResume>(
      _onResume,
      transformer: throttle(const Duration(seconds: 3)),
    );
  }

  FutureOr<void> _init(MainInit event, Emitter<MainState> emit) async {
    final notificationEntity = event.notificationEntity;
    bool hasPermission = await FortunePermissionUtil.requestPermission([Permission.location]);
    final futureAd = adManager.loadAd();

    /// 위치 권한이 없을 경우.
    /// 권한 동의 다하고, 직전에 해제하고 들어올 수도 있음.
    if (!hasPermission) {
      produceSideEffect(MainRequireLocationPermission());
      return;
    }

    await userMeUseCase().then(
      (value) => value.fold(
        (l) => produceSideEffect(MainError(l)),
        (entity) async {
          final geoLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          final location = LatLng(geoLocation.latitude, geoLocation.longitude);
          emit(state.copyWith(user: entity, ad: futureAd));
          add(MainInitMyLocation(location));
          if (notificationEntity != null) {
            add(MainLandingPage(notificationEntity));
          }
        },
      ),
    );
  }

  /// 위치 정보 초기화.
  FutureOr<void> _initMyLocation(MainInitMyLocation event, Emitter<MainState> emit) async {
    try {
      /// 실제 기기가 아니거나 테스트 계정일 경우 테스트 로케이션을 보여줌.
      final isPhysicalDevice = await getPhysicalMobileDevice();
      final isShowTestLocation = isPhysicalDevice ? false : true;
      final location = event.location;

      /// 테스트 디바이스 일 경우 고정된 현재 위치를 보여줌.
      final locationData = LatLng(
        isShowTestLocation ? simulatorLocation.latitude : location.latitude,
        isShowTestLocation ? simulatorLocation.longitude : location.longitude,
      );

      emit(
        state.copyWith(
          currentLocation: locationData,
          cameraLocation: locationData,
          locationName: await getLocationName(
            locationData.latitude,
            locationData.longitude,
            isDetailStreet: false,
          ),
          isTestDeviceMode: isShowTestLocation,
          isLoading: false,
        ),
      );

      produceSideEffect(
        MainLocationChangeListenSideEffect(
          location: locationData,
          destZoom: state.zoomThreshold,
          isInitialize: true,
        ),
      );
      // 마커 불러오기.
      add(MainMarkerList(location));
    } catch (e) {
      FortuneLogger.error(message: e.toString());
    }
  }

  FutureOr<void> _markerList(MainMarkerList event, Emitter<MainState> emit) async {
    await markerListUseCase(state.currentLocation).then(
      (value) => value.fold(
        (l) => produceSideEffect(MainError(l)),
        (r) async {
          // 기존 리스트에 없는 마커만 필터링하여 새 리스트를 만듬.
          var newMarkers = r.list
              .where((newMarker) => !state.markerList.any((existingMarker) => existingMarker.id == newMarker.id))
              .toList();

          // 기존 리스트에 새로운 마커 추가
          List<MarkerEntity> updatedMarkerList = List.from(state.markerList)..addAll(newMarkers);
          emit(
            state.copyWith(
              currentLocation: event.location,
              markerList: updatedMarkerList,
            ),
          );
        },
      ),
    );
  }

  FutureOr<void> _locationChange(MainLocationChange event, Emitter<MainState> emit) async {
    // 테스트 모드 일경우 위치 변경 이벤트 받지 않음.
    if (state.isTestDeviceMode) {
      return;
    }

    final currentLocation = state.currentLocation;
    final nextLocation = event.location;

    var distanceInMeters = Geolocator.distanceBetween(
      currentLocation.latitude,
      currentLocation.longitude,
      nextLocation.latitude,
      nextLocation.longitude,
    );

    emit(
      state.copyWith(
        cameraLocation: event.location,
      ),
    );

    produceSideEffect(
      MainLocationChangeListenSideEffect(
        location: event.location,
        destZoom: state.zoomThreshold,
      ),
    );

    // 30미터 이상 이동했을때 마커리스트 불러옴.
    if (distanceInMeters >= 30) {
      FortuneLogger.info("## 이동거리:: $distanceInMeters");
      add(MainMarkerList(event.location));
    }
  }

  FutureOr<void> _rotate(MainCompassRotate event, Emitter<MainState> emit) async {
    double direction = event.data.heading ?? 0;
    var prevHeadings = state.prevHeadings;
    var turns = state.turns;

    direction = direction < 0 ? (360 + direction) : direction;
    double diff = direction - prevHeadings;
    if (diff.abs() > 180) {
      if (prevHeadings > direction) {
        diff = 360 - (direction - prevHeadings).abs();
      } else {
        diff = 360 - (prevHeadings - direction).abs();
        diff = diff * -1;
      }
    }
    turns += (diff / 360);
    prevHeadings = direction;
    emit(
      state.copyWith(
        turns: turns,
        prevHeadings: prevHeadings,
      ),
    );
  }

  FutureOr<void> _markerClick(MainMarkerClick event, Emitter<MainState> emit) async {
    final remainCoinChangeCount = state.user.remainCoinChangeCount;
    final ad = state.ad;
    final isShowAd = remainCoinChangeCount <= 0 && event.entity.itemType == MarkerItemType.COIN;
    final marker = event.entity;
    final distance = event.distance;

    /// 거리가 모자랄 경우(릴리즈에서만 검사함)
    if (distance > 0 && kReleaseMode) {
      produceSideEffect(MainRequireInCircleMetersEvent(distance));
      return;
    }

    if (isShowAd) {
      // #1 광고를 봐야 할 경우.
      produceSideEffect(
        MainShowAdDialog(
          ts: state.user.timestamps.ad,
          targetMarker: marker,
          ad: ad,
        ),
      );
      return;
    } else if (event.entity.itemType != MarkerItemType.COIN) {
      // #2 코인이 아닌 경우 다이얼로그 노출.
      produceSideEffect(
        MainShowObtainDialog(
          marker: marker,
          timestamp: state.user.timestamps.marker,
          location: state.cameraLocation,
        ),
      );
    } else {
      // #3 코인 일 경우 그냥 획득.
      produceSideEffect(
        MainObtainMarker(
          marker: marker,
          timestamp: state.user.timestamps.marker,
          location: state.cameraLocation,
        ),
      );
    }
  }

  FutureOr<void> _onAdShowComplete(MainOnAdShowComplete event, Emitter<MainState> emit) async {
    // 광고를 다보고 새로운 광고를 다시 채워놔야 함.
    emit(
      state.copyWith(
        user: event.user,
        ad: adManager.loadAd(),
      ),
    );
    produceSideEffect(
      MainObtainMarker(
        marker: event.targetMarker,
        timestamp: event.user.timestamps.marker,
        location: state.cameraLocation,
      ),
    );
  }

  FutureOr<void> _obtainSuccess(MainObtainSuccess event, Emitter<MainState> emit) async {
    final responseEntity = event.entity;
    final targetMarker = responseEntity.marker;
    final targetUser = responseEntity.user;

    final updatedMarkerList = state.markerList.map((marker) {
      if (marker.id == targetMarker.id) {
        return marker.copyWith(
          latitude: targetMarker.latitude,
          longitude: targetMarker.longitude,
        );
      }
      return marker; // 다른 마커는 변경 없이 그대로 반환
    }).toList();

    emit(
      state.copyWith(
        user: targetUser,
        markerList: updatedMarkerList,
      ),
    );
  }

  FutureOr<void> _onResume(MainOnResume event, Emitter<MainState> emit) async {
    FortuneLogger.info("onResume");
    await userMeUseCase().then(
      (value) => value.fold(
        (l) => produceSideEffect(MainError(l)),
        (entity) async {
          emit(state.copyWith(user: entity));
        },
      ),
    );
  }
}
