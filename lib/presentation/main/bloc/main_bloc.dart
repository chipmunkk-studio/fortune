import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/util/permission.dart';
import 'package:fortune/data/supabase/service/service_ext.dart';
import 'package:fortune/domain/supabase/request/request_main_param.dart';
import 'package:fortune/domain/supabase/request/request_obtain_marker_param.dart';
import 'package:fortune/domain/supabase/usecase/get_show_ad_use_case.dart';
import 'package:fortune/domain/supabase/usecase/main_use_case.dart';
import 'package:fortune/domain/supabase/usecase/obtain_marker_use_case.dart';
import 'package:fortune/env.dart';
import 'package:fortune/fortune_router.dart';
import 'package:fortune/presentation/main/component/map/main_location_data.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'main.dart';

class MainBloc extends Bloc<MainEvent, MainState> with SideEffectBlocMixin<MainEvent, MainState, MainSideEffect> {
  static const tag = "[CountryCodeBloc]";

  final MainUseCase mainUseCase;
  final ObtainMarkerUseCase obtainMarkerUseCase;
  final FortuneRemoteConfig remoteConfig;
  final GetShowAdUseCase getShowAdUseCase;

  MainBloc({
    required this.remoteConfig,
    required this.mainUseCase,
    required this.obtainMarkerUseCase,
    required this.getShowAdUseCase,
  }) : super(MainState.initial()) {
    on<MainInit>(init);
    on<MainLandingPage>(landingPage);
    on<Main>(
      main,
      transformer: throttle(const Duration(seconds: 3)),
    );
    on<MainMarkerClick>(onMarkerClicked);
    on<MainRequireInCircleMetersEvent>(
      _toastRequireMeters,
      transformer: throttle(const Duration(seconds: 2)),
    );
    on<MainMyLocationChange>(
      locationChange,
      transformer: debounce(const Duration(seconds: 2)),
    );
    on<MainSetRewardAd>(setRewardAd);
    on<MainScreenFreeze>(_screenFreeze);
    on<MainMarkerObtain>(
      _markerObtain,
      transformer: sequential(),
    );
  }

  FutureOr<void> landingPage(MainLandingPage event, Emitter<MainState> emit) async {
    final landingPage = event.entity.landingRoute;
    if (landingPage.isNotEmpty) {
      switch (landingPage) {
        case Routes.obtainHistoryRoute:
          final searchText = event.entity.searchText;
          if (searchText.isNotEmpty) {
            return produceSideEffect(MainSchemeLandingPage(landingPage, searchText: searchText));
          }

          Location location = Location();
          LocationData locationData = await location.getLocation();

          final latitude = locationData.latitude;
          final longitude = locationData.longitude;

          if (latitude != null && longitude != null) {
            final locationName = await getLocationName(
                  latitude,
                  longitude,
                  isDetailStreet: false,
                ) ??
                state.locationName;
            return produceSideEffect(MainSchemeLandingPage(landingPage, searchText: locationName));
          }

          return produceSideEffect(MainSchemeLandingPage(landingPage));
        default:
          produceSideEffect(MainSchemeLandingPage(landingPage));
      }
    }
  }

  FutureOr<void> init(MainInit event, Emitter<MainState> emit) async {
    final notificationEntity = event.notificationEntity;
    bool hasPermission = await FortunePermissionUtil.requestPermission([Permission.location]);

    // 위치 권한이 없을 경우.
    if (!hasPermission) {
      produceSideEffect(MainRequireLocationPermission());
      return;
    }
    // 마커 목록들을 받아옴.
    add(Main());

    if (notificationEntity != null) {
      add(MainLandingPage(notificationEntity));
    }
  }

  // 위치 정보 초기화.
  FutureOr<void> main(Main event, Emitter<MainState> emit) async {
    Location location = Location();
    LocationData locationData = await location.getLocation();

    // #1 내 위치먼저 찍음.
    emit(state.copyWith(myLocation: locationData));

    // #1-1 카메라 센터를 내 현재위치로 변경.
    produceSideEffect(MainLocationChangeListenSideEffect(location, locationData));

    // #3 소켓연결해서 리스트 변경 감지.
    await getMain(emit);
  }

  // 메인 화면을 구성하는데 필요한 모든 정보를 가져옴.
  getMain(Emitter<MainState> emit) async {
    final myLoc = state.myLocation;
    if (myLoc != null) {
      await mainUseCase(
        RequestMainParam(
          longitude: myLoc.longitude ?? 0,
          latitude: myLoc.latitude ?? 0,
        ),
      ).then(
        (value) => value.fold(
          (l) {
            emit(state.copyWith(isLoading: false));
            produceSideEffect(MainError(l));
          },
          (entity) async {
            // 마커들.
            final markerList = entity.markers
                .map(
                  (e) => MainLocationData(
                    id: e.id,
                    location: LatLng(e.latitude, e.longitude),
                    ingredient: e.ingredient,
                    isObtainedUser: e.lastObtainUser != null,
                  ),
                )
                .toList();
            emit(
              state.copyWith(
                markers: markerList,
                user: entity.user,
                notices: entity.notices,
                haveCount: entity.haveCount,
                missionClearUsers: entity.missionClearUsers,
                isLoading: false,
              ),
            );
          },
        ),
      );
    }
  }

  // 위치 변경 시.
  FutureOr<void> locationChange(MainMyLocationChange event, Emitter<MainState> emit) async {
    final latitude = event.newLoc.latitude;
    final longitude = event.newLoc.longitude;

    if (latitude != null && longitude != null) {
      final locationName = await getLocationName(latitude, longitude, isDetailStreet: false) ?? state.locationName;
      emit(
        state.copyWith(
          myLocation: event.newLoc,
          locationName: locationName,
        ),
      );
    }
  }

  // 마커 클릭 시.
  FutureOr<void> onMarkerClicked(MainMarkerClick event, Emitter<MainState> emit) async {
    final data = event.data;
    final distance = event.distance;
    final isShowAd = await getShowAdUseCase().then((value) => value.getOrElse(() => false));

    // 거리가 모자랄 경우
    if (event.distance > 0) {
      add(MainRequireInCircleMetersEvent(distance));
      return;
    }

    // 다이얼로그 노출.
    produceSideEffect(
      MainShowObtainDialog(
        data: data,
        key: event.globalKey,
        isShowAd: isShowAd,
      ),
    );
  }

  FutureOr<void> _markerObtain(MainMarkerObtain event, Emitter<MainState> emit) async {
    add(MainScreenFreeze(flag: true, data: event.data));

    final marker = event.data;
    final latitude = marker.location.latitude;
    final longitude = marker.location.longitude;
    final krLocationName = state.locationName;

    // todo 영어 위치.
    // final enLocationName = await getLocationName(latitude, longitude, localeIdentifier: "en_US");

    await obtainMarkerUseCase(
      RequestObtainMarkerParam(
        marker: marker,
        kLocation: krLocationName,
      ),
    ).then(
      (value) => value.fold(
        (l) {
          add(MainScreenFreeze(flag: false, data: event.data));
          produceSideEffect(MainError(l));
        },
        (result) async {
          List<MainLocationData> newList = List.from(state.markers);
          var loc = state.markers.firstWhereOrNull((element) => element.location == event.data.location);
          newList.remove(loc);

          produceSideEffect(
            MainMarkerObtainSuccessSideEffect(
              key: event.key,
              data: event.data,
              isAnimation: event.data.ingredient.type != IngredientType.coin,
            ),
          );

          emit(
            state.copyWith(
              markers: newList,
              user: result.user,
              haveCount: result.haveCount,
              isObtainProcessing: false,
            ),
          );

          // todo 레벨업 혹은 등급업일 경우 다이얼로그 노출
          // if (result.isLevelOrGradeUp) {
          //   produceSideEffect(
          //     MainShowDialog(
          //       landingRoute: Routes.obtainHistoryRoute,
          //       title: result.dialogHeadings,
          //       subTitle: result.dialogContent,
          //     ),
          //   );
          // }
          add(MainScreenFreeze(flag: false, data: event.data));
          await getMain(emit);
        },
      ),
    );
  }

  FutureOr<void> setRewardAd(MainSetRewardAd event, Emitter<MainState> emit) async {
    emit(
      state.copyWith(
        rewardAd: event.ad,
      ),
    );
  }

  FutureOr<void> _screenFreeze(MainScreenFreeze event, Emitter<MainState> emit) async {
    emit(
      state.copyWith(
        isObtainProcessing: event.flag,
        processingMarker: event.data,
      ),
    );
  }

  FutureOr<void> _toastRequireMeters(MainRequireInCircleMetersEvent event, Emitter<MainState> emit) {
    produceSideEffect(MainRequireInCircleMeters(event.distance));
  }
}
