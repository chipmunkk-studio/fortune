import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/core/util/permission.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/request/request_insert_history_param.dart';
import 'package:foresh_flutter/domain/supabase/request/request_main_param.dart';
import 'package:foresh_flutter/domain/supabase/usecase/insert_obtain_history_use_case.dart';
import 'package:foresh_flutter/domain/supabase/usecase/main_use_case.dart';
import 'package:foresh_flutter/domain/supabase/usecase/obtain_marker_use_case.dart';
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

  MainBloc({
    required this.mainUseCase,
    required this.obtainMarkerUseCase,
    required this.insertObtainHistoryUseCase,
  }) : super(MainState.initial()) {
    on<MainInit>(init);
    on<Main>(main);
    on<MainMarkerClick>(onMarkerClicked);
    on<MainMyLocationChange>(locationChange);
    on<MainTimeOver>(timerOver);
  }

  FutureOr<void> init(MainInit event, Emitter<MainState> emit) async {
    // generateRandomMarkers();
    bool hasPermission = await FortunePermissionUtil.requestPermission([Permission.location]);

    // 알람으로 랜딩할 경우 페이지.
    final landingPage = event.landingPage;

    // 위치 권한이 없을 경우.
    if (!hasPermission) {
      produceSideEffect(MainRequireLocationPermission());
      return;
    }
    // 마커 목록들을 받아옴.
    add(Main());

    // 랜딩페이지가 있을 경우.
    if (landingPage != null) {
      produceSideEffect(MainSchemeLandingPage(landingPage));
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
                refreshTime: 10,
                refreshCount: state.refreshCount + 1,
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
    emit(state.copyWith(myLocation: event.newLoc));
  }

  // 마커 클릭 시.
  FutureOr<void> onMarkerClicked(MainMarkerClick event, Emitter<MainState> emit) async {
    final data = event.data;
    final distance = event.distance;
    final latitude = data.location.latitude;
    final longitude = data.location.longitude;

    // 티켓이 있을 경우만.
    // 먼저 처리 하고 api를 나중에 쏨. 아니면 느림.
    if (state.user?.ticket != 0 || (data.ingredient.isExtinct && data.isObtainedUser)) {
      List<MainLocationData> newList = List.from(state.markers);
      var loc = state.markers.firstWhereOrNull((element) => element.location == event.data.location);
      if (loc != null) {
        newList.remove(loc);
        emit(state.copyWith(markers: newList));
      }
      produceSideEffect(
        MainMarkerClickSideEffect(
          key: event.globalKey,
          newList: newList,
        ),
      );
    }

    // if (distance < 0) {
    await obtainMarkerUseCase(data.id).then(
      (value) => value.fold(
        (l) => produceSideEffect(MainError(l)),
        (r) async {
          emit(state.copyWith(user: r));
          FortuneLogger.info("레벨: ${r.level}, 다음 레벨 까지: ${r.percentageNextLevel},등급: ${r.grade.name}");
          // 획득 응답 속도 때문에 usecase로 따로 실행하고 에러는 무시.
          if (data.ingredient.type != IngredientType.ticket) {
            await insertObtainHistoryUseCase(
              RequestInsertHistoryParam(
                userId: r.id,
                markerId: data.id.toString(),
                ingredientId: data.ingredient.id,
                ingredientName: data.ingredient.name,
                nickname: r.nickname,
                krLocationName: await getLocationName(latitude, longitude),
                enLocationName: await getLocationName(latitude, longitude, localeIdentifier: "en_US"),
              ),
            ).then((value) => value.getOrElse(() {
                  // 에러 무시
                }));
          }
        },
      ),
    );
    // );
    // } else {
    //   produceSideEffect(MainRequireInCircleMeters(distance));
    // }
  }

  FutureOr<void> timerOver(MainTimeOver event, Emitter<MainState> emit) async {
    await getMain(emit);
  }
}
