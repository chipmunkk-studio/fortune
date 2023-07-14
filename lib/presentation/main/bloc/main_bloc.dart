import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/core/util/permission.dart';
import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/request/request_insert_history_param.dart';
import 'package:foresh_flutter/domain/supabase/request/request_level_or_grade_up_param.dart';
import 'package:foresh_flutter/domain/supabase/request/request_main_param.dart';
import 'package:foresh_flutter/domain/supabase/request/request_re_locate_marker_param.dart';
import 'package:foresh_flutter/domain/supabase/usecase/get_fortune_user_use_case.dart';
import 'package:foresh_flutter/domain/supabase/usecase/get_obtain_count_use_case.dart';
import 'package:foresh_flutter/domain/supabase/usecase/insert_obtain_history_use_case.dart';
import 'package:foresh_flutter/domain/supabase/usecase/level_or_grade_up_use_case.dart';
import 'package:foresh_flutter/domain/supabase/usecase/main_use_case.dart';
import 'package:foresh_flutter/domain/supabase/usecase/obtain_marker_use_case.dart';
import 'package:foresh_flutter/domain/supabase/usecase/post_mission_relay_clear_use_case.dart';
import 'package:foresh_flutter/domain/supabase/usecase/re_locate_marker_use_case.dart';
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
  final GetObtainableMarkerUseCase getObtainableMarkerUseCase;
  final ReLocateMarkerUseCase reLocateMarkerUseCase;
  final PostMissionRelayClearUseCase postMissionRelayClearUseCase;
  final LevelOrGradeUpUseCase levelOrGradeUpUseCase;
  final FortuneRemoteConfig remoteConfig;

  MainBloc({
    required this.remoteConfig,
    required this.mainUseCase,
    required this.obtainMarkerUseCase,
    required this.insertObtainHistoryUseCase,
    required this.getObtainCountUseCase,
    required this.getObtainableMarkerUseCase,
    required this.reLocateMarkerUseCase,
    required this.postMissionRelayClearUseCase,
    required this.levelOrGradeUpUseCase,
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
                // refreshTime: 10,
                notices: entity.notices,
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
    List<MainLocationData> newList = List.from(state.markers);
    await getObtainableMarkerUseCase(data).then(
      (value) => value.fold(
        (l) => produceSideEffect(MainError(l)),
        (r) {
          var loc = state.markers.firstWhereOrNull((element) => element.location == event.data.location);
          // 획득 후 제거.
          if (loc != null) {
            newList.remove(loc);
            emit(state.copyWith(markers: newList));
          }
          // 애니메이션 수행 여부 확인.
          if (event.isAnimation) {
            produceSideEffect(
              MainMarkerClickSideEffect(
                key: event.globalKey,
                data: data,
              ),
            );
          }
          emit(
            state.copyWith(
              processingCount: state.processingCount + 1,
            ),
          );
          // 마커 획득 이벤트 수행.
          add(MainMarkerObtain(data));
        },
      ),
    );
  }

  FutureOr<void> timerOver(MainTimeOver event, Emitter<MainState> emit) async {
    await getMain(emit);
  }

  FutureOr<void> _markerObtain(MainMarkerObtain event, Emitter<MainState> emit) async {
    final marker = event.data;

    final latitude = marker.location.latitude;
    final longitude = marker.location.longitude;
    final krLocationName = await getLocationName(latitude, longitude);
    final enLocationName = await getLocationName(latitude, longitude, localeIdentifier: "en_US");

    // 마커 획득.
    // #1 티켓 감소.
    await obtainMarkerUseCase(marker).then(
      (value) => value.fold(
        (l) => produceSideEffect(MainError(l)),
        (user) async {
          // #2 레벨업 여부 확인
          _confirmLevelOrGradeUp(prevUser: state.user!, nextUser: user);

          emit(state.copyWith(user: user));

          // #3 마커 랜덤 배치. (티켓 감소 후 획득 했다고 판단)
          await reLocateMarkerUseCase(
            RequestReLocateMarkerParam(
              markerId: marker.id,
              user: state.user!,
            ),
          );

          // #4 티켓이 아닌 경우에만. (획득 처리 다음 히스토리 추가)
          await insertObtainHistoryUseCase(
            RequestInsertHistoryParam(
              userId: user.id,
              ingredientType: marker.ingredient.type,
              markerId: marker.id.toString(),
              ingredientId: marker.ingredient.id,
              ingredientName: marker.ingredient.name,
              nickname: user.nickname,
              krLocationName: krLocationName,
              enLocationName: enLocationName,
            ),
          ).then(
            (value) => value.fold(
              (l) => produceSideEffect(MainError(l)),
              (histories) async {
                emit(
                  state.copyWith(
                    haveCount: histories != null ? histories.length : state.haveCount,
                    processingCount: state.processingCount - 1,
                  ),
                );
                if (histories != null) {
                  await postMissionRelayClearUseCase(marker.id).then(
                    (value) => value.fold(
                      (l) => null,
                      (isClear) {
                        if (isClear) {
                          produceSideEffect(
                            MainShowDialog(
                              landingRoute: Routes.userNoticesRoute,
                              title: '릴레이 미션을 클리어 하셨습니다!!',
                              subTitle: '축하합니다',
                            ),
                          );
                        }
                      },
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  _confirmLevelOrGradeUp({
    required FortuneUserEntity prevUser,
    required FortuneUserEntity nextUser,
  }) async {
    FortuneLogger.info("_confirmLevelOrGradeUp");
    await levelOrGradeUpUseCase(
      RequestLevelOrGradeUpParam(
        prevUser: prevUser,
        nextUser: nextUser,
      ),
    ).then(
      (value) => value.fold(
        (l) => null,
        (entity) {
          // switch (type) {
          //   case UserNoticeType.grade_up:
          //   case UserNoticeType.level_up:
          //     produceSideEffect(
          //       MainShowDialog(
          //         title: "레벨 업을 축하합니다!",
          //         landingRoute: Routes.userNoticesRoute,
          //         subTitle: '새로운 알림을 확인해보세요.',
          //       ),
          //     );
          //     break;
          //   default:
          //     break;
          // }
        },
      ),
    );
  }
}
