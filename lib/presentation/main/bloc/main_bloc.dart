import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/core/util/permission.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/request/request_insert_history_param.dart';
import 'package:foresh_flutter/domain/supabase/request/request_main_param.dart';
import 'package:foresh_flutter/domain/supabase/usecase/get_obtain_count_use_case.dart';
import 'package:foresh_flutter/domain/supabase/usecase/insert_obtain_history_use_case.dart';
import 'package:foresh_flutter/domain/supabase/usecase/main_use_case.dart';
import 'package:foresh_flutter/domain/supabase/usecase/obtain_marker_use_case.dart';
import 'package:foresh_flutter/domain/supabase/usecase/post_mission_relay_clear_use_case.dart';
import 'package:foresh_flutter/env.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/main/component/map/main_location_data.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'main.dart';

class MainBloc extends Bloc<MainEvent, MainState> with SideEffectBlocMixin<MainEvent, MainState, MainSideEffect> {
  static const tag = "[CountryCodeBloc]";

  final MainUseCase mainUseCase;
  final ObtainMarkerUseCase obtainMarkerUseCase;
  final InsertObtainHistoryUseCase insertObtainHistoryUseCase;
  final GetObtainCountUseCase getObtainCountUseCase;
  final PostMissionRelayClearUseCase postMissionRelayClearUseCase;
  final FortuneRemoteConfig remoteConfig;

  MainBloc({
    required this.remoteConfig,
    required this.mainUseCase,
    required this.obtainMarkerUseCase,
    required this.insertObtainHistoryUseCase,
    required this.postMissionRelayClearUseCase,
    required this.getObtainCountUseCase,
  }) : super(MainState.initial()) {
    on<MainInit>(init);
    on<MainLandingPage>(landingPage);
    on<Main>(main);
    on<MainMarkerClick>(
      onMarkerClicked,
      transformer: sequential(),
    );
    on<MainMyLocationChange>(locationChange);
    on<MainTimeOver>(timerOver);
    on<MainMarkerObtain>(
      _markerObtain,
      transformer: sequential(),
    );
  }

  FutureOr<void> landingPage(MainLandingPage event, Emitter<MainState> emit) async {
    final landingPage = event.entity.entity?.landingRoute;
    if (landingPage != null) {
      switch (landingPage) {
        case Routes.obtainHistoryRoute:
          final searchText = event.entity.entity?.searchText;
          if (searchText != null) {
            return produceSideEffect(MainSchemeLandingPage(landingPage, searchText: searchText));
          }

          Location location = Location();
          LocationData locationData = await location.getLocation();

          final latitude = locationData.latitude;
          final longitude = locationData.longitude;

          if (latitude != null && longitude != null) {
            final locationName = await getLocationName(latitude, longitude, isDetailStreet: false);
            return produceSideEffect(MainSchemeLandingPage(landingPage, searchText: locationName));
          }

          return produceSideEffect(MainSchemeLandingPage(landingPage));
        default:
          produceSideEffect(MainSchemeLandingPage(landingPage));
      }
    }
  }

  FutureOr<void> init(MainInit event, Emitter<MainState> emit) async {
    // generateRandomMarkers();
    bool hasPermission = await FortunePermissionUtil.requestPermission([Permission.location]);

    // 위치 권한이 없을 경우.
    if (!hasPermission) {
      produceSideEffect(MainRequireLocationPermission());
      return;
    }
    // 마커 목록들을 받아옴.
    add(Main());
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

  getMain(Emitter<MainState> emit) async {
    // 메인 화면을 구성하는데 필요한 모든 정보를 가져옴.
    final myLoc = state.myLocation;

    if (myLoc != null) {
      await mainUseCase(
        RequestMainParam(
          longitude: myLoc.longitude ?? 0,
          latitude: myLoc.latitude ?? 0,
        ),
      ).then(
        (value) => value.fold(
          (l) => produceSideEffect(MainError(l)),
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
                refreshTime: remoteConfig.refreshTime,
                refreshCount: state.refreshCount + 1,
                haveCount: entity.haveCount,
                histories: entity.histories,
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
      final locationName = await getLocationName(
        latitude,
        longitude,
        isDetailStreet: false,
      );
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
    List<MainLocationData> newList = List.from(state.markers);
    var loc = state.markers.firstWhereOrNull((element) => element.location == event.data.location);
    if (loc != null) {
      newList.remove(loc);
      emit(state.copyWith(markers: newList));
    }

    // 티켓인 경우 다이얼로그로 노출.
    if (data.ingredient.type == IngredientType.ticket && !data.isObtainedUser) {
      produceSideEffect(MainShowDialog());
    } else {
      // 티켓이 아닌 경우 획득 애니메이션.
      produceSideEffect(
        MainMarkerClickSideEffect(
          key: event.globalKey,
          data: data,
        ),
      );
    }
    add(MainMarkerObtain(data));
    //
    //
    // if (distance < 0) {
    //   // 티켓이 있을 경우만.
    //   // 먼저 처리 하고 api를 나중에 쏨. 아니면 느림.
    //   if (state.user?.ticket != 0 || (data.ingredient.isExtinct && data.isObtainedUser)) {
    //     List<MainLocationData> newList = List.from(state.markers);
    //     var loc = state.markers.firstWhereOrNull((element) => element.location == event.data.location);
    //     if (loc != null) {
    //       newList.remove(loc);
    //       emit(state.copyWith(markers: newList));
    //     }
    //     produceSideEffect(
    //       MainMarkerClickSideEffect(
    //         key: event.globalKey,
    //         data: data,
    //       ),
    //     );
    //   }
    //   // 여기에 넣으면됨.
    // } else {
    //   produceSideEffect(MainRequireInCircleMeters(distance));
    // }
  }

  FutureOr<void> timerOver(MainTimeOver event, Emitter<MainState> emit) async {
    await getMain(emit);
  }

  FutureOr<void> _markerObtain(MainMarkerObtain event, Emitter<MainState> emit) async {
    final marker = event.data;

    final latitude = marker.location.latitude;
    final longitude = marker.location.longitude;

    await obtainMarkerUseCase(marker.id).then(
      (value) => value.fold(
        (l) => produceSideEffect(MainError(l)),
        (r) async {
          emit(state.copyWith(user: r));
          // 티켓이 아니고, 소멸성이 아닌 경우에만 올림.
          if (marker.ingredient.type != IngredientType.ticket && !marker.ingredient.isExtinct) {
            await insertObtainHistoryUseCase(
              RequestInsertHistoryParam(
                userId: r.id,
                markerId: marker.id.toString(),
                ingredientId: marker.ingredient.id,
                ingredientName: marker.ingredient.name,
                nickname: r.nickname,
                krLocationName: await getLocationName(latitude, longitude),
                enLocationName: await getLocationName(latitude, longitude, localeIdentifier: "en_US"),
              ),
            ).then(
              (value) => value.fold(
                (l) => produceSideEffect(MainError(l)),
                (r) async {
                  emit(state.copyWith(haveCount: r));
                  await postMissionRelayClearUseCase(marker.id).then(
                    (value) => value.fold(
                      (l) => null,
                      (r) {
                        if (r) {
                          FortuneLogger.info("릴레이 미션 당첨!");
                        }
                      },
                    ),
                  );
                },
              ),
            );
          } else {
            await getObtainCountUseCase(r.id).then(
              (value) => value.fold(
                (l) => produceSideEffect(MainError(l)),
                (r) => emit(state.copyWith(haveCount: r)),
              ),
            );
          }
        },
      ),
    );
  }
}
