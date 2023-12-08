import 'dart:async';
import 'dart:math' as math;

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/fortune_ext.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/core/util/mixpanel.dart';
import 'package:fortune/core/util/permission.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/domain/supabase/request/request_main_param.dart';
import 'package:fortune/domain/supabase/request/request_obtain_marker_param.dart';
import 'package:fortune/domain/supabase/usecase/get_app_update.dart';
import 'package:fortune/domain/supabase/usecase/get_ingredients_by_type_use_case.dart';
import 'package:fortune/domain/supabase/usecase/get_random_box_timer_counter_use_case.dart';
import 'package:fortune/domain/supabase/usecase/get_show_ad_use_case.dart';
import 'package:fortune/domain/supabase/usecase/main_use_case.dart';
import 'package:fortune/domain/supabase/usecase/obtain_marker_default_use_case.dart';
import 'package:fortune/domain/supabase/usecase/obtain_marker_main_use_case.dart';
import 'package:fortune/domain/supabase/usecase/read_alarm_feed_use_case.dart';
import 'package:fortune/domain/supabase/usecase/set_random_box_timer_counter_use_case.dart';
import 'package:fortune/env.dart';
import 'package:fortune/presentation/giftbox/giftbox_action_param.dart';
import 'package:fortune/presentation/main/component/map/main_location_data.dart';
import 'package:fortune/presentation/main/main_ext.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'main.dart';

class MainBloc extends Bloc<MainEvent, MainState> with SideEffectBlocMixin<MainEvent, MainState, MainSideEffect> {
  static const tag = "[CountryCodeBloc]";

  final GetAppUpdate getAppUpdate;
  final MainUseCase mainUseCase;
  final ObtainMarkerMainUseCase obtainMarkerMainUseCase;
  final FortuneRemoteConfig remoteConfig;
  final GetShowAdUseCase getShowAdUseCase;
  final ReadAlarmFeedUseCase readAlarmFeedUseCase;
  final GetIngredientsByTypeUseCase getIngredientsByTypeUseCase;
  final MixpanelTracker tracker;
  final ObtainMarkerDefaultUseCase obtainMarkerDefaultUseCase;
  final SetRandomBoxTimerCounterUseCase setRandomBoxTimerCounterUseCase;
  final GetRandomBoxTimerCounterUseCase getRandomBoxTimerCounterUseCase;

  MainBloc({
    required this.remoteConfig,
    required this.mainUseCase,
    required this.getAppUpdate,
    required this.obtainMarkerMainUseCase,
    required this.getShowAdUseCase,
    required this.readAlarmFeedUseCase,
    required this.getIngredientsByTypeUseCase,
    required this.obtainMarkerDefaultUseCase,
    required this.tracker,
    required this.setRandomBoxTimerCounterUseCase,
    required this.getRandomBoxTimerCounterUseCase,
  }) : super(MainState.initial()) {
    on<MainInit>(init);
    on<MainLandingPage>(landingPage);
    on<Main>(
      main,
      transformer: throttle(const Duration(seconds: 5)),
    );
    on<MainMarkerClick>(onMarkerClicked);
    on<MainRequireInCircleMetersEvent>(
      _toastRequireMeters,
      transformer: throttle(const Duration(seconds: 2)),
    );
    on<MainMyLocationChange>(locationChange);
    on<MainSetRewardAd>(setRewardAd);
    on<MainScreenFreeze>(_screenFreeze);
    on<MainAlarmRead>(_readAlarm);
    on<MainMapRotate>(
      _rotate,
      transformer: sequential(),
    );
    on<MainMarkerObtain>(
      _markerObtain,
      transformer: sequential(),
    );
    on<MainRandomBoxTimerCount>(_randomBoxTimerCount);
    on<MainOpenRandomBox>(_openRandomBox);
    on<MainMarkerObtainFromRandomBox>(_markerObtainFromRandomBox);
  }

  FutureOr<void> landingPage(MainLandingPage event, Emitter<MainState> emit) async {
    final landingPage = event.entity.landingRoute;
    if (landingPage.isNotEmpty) {
      switch (landingPage) {
        case AppRoutes.obtainHistoryRoute:
          final searchText = event.entity.searchText;

          if (searchText.isNotEmpty) {
            return produceSideEffect(MainSchemeLandingPage(landingPage, searchText: searchText));
          }

          final locationData = await Geolocator.getCurrentPosition(desiredAccuracy: mapLocationAccuracy);

          final latitude = locationData.latitude;
          final longitude = locationData.longitude;

          final locationName = await getLocationName(latitude, longitude, isDetailStreet: false);

          return produceSideEffect(
            MainSchemeLandingPage(
              landingPage,
              searchText: locationName,
            ),
          );
        default:
          produceSideEffect(MainSchemeLandingPage(landingPage));
      }
    }
  }

  FutureOr<void> init(MainInit event, Emitter<MainState> emit) async {
    await getAppUpdate().then(
      (value) => value.fold(
        (l) => produceSideEffect(MainError(l)),
        (r) async {
          if (r != null && (r.isActive || r.isForceUpdate)) {
            produceSideEffect(MainShowAppUpdate(entity: r));
          } else {
            final notificationEntity = event.notificationEntity;
            bool hasPermission = await FortunePermissionUtil.requestPermission([Permission.location]);
            // 위치 권한이 없을 경우.
            if (!hasPermission) {
              produceSideEffect(MainRequireLocationPermission());
              return;
            }

            // 실제 기기가 아니거나 테스트 계정일 경우 테스트 로케이션을 보여줌.
            final isPhysicalDevice = await getPhysicalMobileDevice();
            final currentUserEmail = Supabase.instance.client.auth.currentUser?.email;
            final isTestAccount = currentUserEmail == remoteConfig.testSignInEmail;
            final isShowTestLocation = isPhysicalDevice ? false : isTestAccount;
            final randomBoxInitialTime = await getRandomBoxTimerCounterUseCase().then(
              (value) => value.getOrElse(() => remoteConfig.randomBoxTimer),
            );

            emit(
              state.copyWith(
                randomBoxTimerSecond: randomBoxInitialTime,
                randomBoxOpenable: randomBoxInitialTime == 0,
                myLocation: isShowTestLocation ? simulatorLocation : null,
                isShowTestLocation: isShowTestLocation,
                locationName: isShowTestLocation
                    ? await getLocationName(
                        simulatorLocation.latitude,
                        simulatorLocation.longitude,
                        isDetailStreet: false,
                      )
                    : state.locationName,
              ),
            );

            // 마커 목록들을 받아옴.
            add(Main());

            if (notificationEntity != null) {
              add(MainLandingPage(notificationEntity));
            }
          }
        },
      ),
    );
  }

  // 위치 정보 초기화.
  FutureOr<void> main(Main event, Emitter<MainState> emit) async {
    try {
      final isShowTestLocation = state.isShowTestLocation;
      final nextLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: isShowTestLocation ? LocationAccuracy.lowest : LocationAccuracy.high,
      );
      final prevLocation = state.myLocation ?? nextLocation;

      // #0 테스트 디바이스 일 경우 고정된 현재 위치를 보여줌.
      final locationData = isShowTestLocation ? prevLocation : nextLocation;

      // #1 내 위치먼저 찍음.
      emit(state.copyWith(myLocation: locationData));

      // #1-1 카메라 센터를 내 현재위치로 변경.
      produceSideEffect(
        MainLocationChangeListenSideEffect(
          locationData,
        ),
      );
      // 마커 목록 불러옴.
      await getMain(emit);
    } catch (e) {
      FortuneLogger.error(message: e.toString());
    }
  }

  // 메인 화면을 구성하는데 필요한 모든 정보를 가져옴.
  getMain(Emitter<MainState> emit) async {
    final myLoc = state.myLocation;
    if (myLoc != null) {
      await mainUseCase(
        RequestMainParam(
          longitude: myLoc.longitude,
          latitude: myLoc.latitude,
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
                  ),
                )
                .toList();
            emit(
              state.copyWith(
                markers: markerList,
                user: entity.user,
                haveCount: entity.haveCount,
                hasNewAlarm: entity.hasNewAlarm,
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
    try {
      final latitude = event.newLoc.latitude;
      final longitude = event.newLoc.longitude;
      final locationName = await getLocationName(latitude, longitude, isDetailStreet: false);
      emit(
        state.copyWith(
          myLocation: event.newLoc,
          locationName: locationName,
        ),
      );
    } catch (e) {
      FortuneLogger.error(message: e.toString());
    }
  }

  // 마커 클릭 시.
  FutureOr<void> onMarkerClicked(MainMarkerClick event, Emitter<MainState> emit) async {
    final data = event.data;
    final distance = event.distance;
    final isShowAd = await getShowAdUseCase().then((value) => value.getOrElse(() => false));

    /// 거리가 모자랄 경우
    if (event.distance > 0 && kReleaseMode) {
      add(MainRequireInCircleMetersEvent(distance));
      return;
    }

    final currentUserTicket = state.user?.ticket ?? 0;
    final ingredient = data.ingredient;
    final requiredTicket = ingredient.rewardTicket.abs();

    /// 티켓이 모자랄 경우.
    if (currentUserTicket < requiredTicket && ingredient.type != IngredientType.coin) {
      produceSideEffect(MainRequiredTicket(requiredTicket - currentUserTicket));
      return;
    }

    // 다이얼로그 노출.
    produceSideEffect(
      MainShowObtainDialog(
        data: data,
        key: event.globalKey,
        isShowAd: isShowAd,
        user: state.user,
        ad: state.rewardAd,
      ),
    );
  }

  FutureOr<void> _markerObtain(MainMarkerObtain event, Emitter<MainState> emit) async {
    add(MainScreenFreeze(flag: true, data: event.data));

    final marker = event.data;
    final krLocationName = state.locationName;

    await obtainMarkerMainUseCase(
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

          final ingredientType = event.data.ingredient.type;

          produceSideEffect(
            MainMarkerObtainSuccessSideEffect(
              key: event.key,
              data: event.data,
              hasAnimation: _hasAnimation(ingredientType),
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

  FutureOr<void> _readAlarm(MainAlarmRead event, Emitter<MainState> emit) async {
    await readAlarmFeedUseCase().then(
      (value) => value.fold(
        (l) => produceSideEffect(
          MainError(l),
        ),
        (r) {
          emit(state.copyWith(hasNewAlarm: false));
        },
      ),
    );
  }

  FutureOr<void> _rotate(MainMapRotate event, Emitter<MainState> emit) async {
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

  FutureOr<void> _randomBoxTimerCount(MainRandomBoxTimerCount event, Emitter<MainState> emit) {
    setRandomBoxTimerCounterUseCase(event.timerCount).then(
      (value) => value.fold(
        (l) => null,
        (r) => emit(
          state.copyWith(
            randomBoxOpenable: event.timerCount == 0 && !state.randomBoxOpenable,
            randomBoxTimerSecond: event.timerCount,
          ),
        ),
      ),
    );
  }

  FutureOr<void> _openRandomBox(MainOpenRandomBox event, Emitter<MainState> emit) async {
    final result = await getIngredientsByTypeUseCase([
      if (event.type == GiftboxType.random) IngredientType.randomScratchSingle,
      if (event.type == GiftboxType.random) IngredientType.randomScratchMulti,
    ]);
    result.fold(
      (l) => produceSideEffect(MainError(l)),
      (r) {
        final ingredient = r[math.Random().nextInt(r.length)];
        final data = MainLocationData(
          location: LatLng(state.myLocation?.latitude ?? 0, state.myLocation?.longitude ?? 0),
          ingredient: ingredient,
        );
        produceSideEffect(
          MainNavigateOpenRandomBox(
            user: state.user,
            ad: state.rewardAd,
            type: event.type,
            data: data,
          ),
        );
      },
    );
  }

  FutureOr<void> _markerObtainFromRandomBox(MainMarkerObtainFromRandomBox event, Emitter<MainState> emit) async {
    add(MainScreenFreeze(flag: true, data: event.data));
    await setRandomBoxTimerCounterUseCase(remoteConfig.randomBoxTimer).then(
      (value) => value.fold(
        (l) => produceSideEffect(MainError(l)),
        (r) async {
          await obtainMarkerDefaultUseCase(event.data.ingredient).then(
            (value) => value.fold(
              (l) => produceSideEffect(MainError(l)),
              (r) async {
                await Future.delayed(const Duration(milliseconds: 200));
                emit(
                  state.copyWith(
                    randomBoxOpenable: false,
                    randomBoxTimerSecond: remoteConfig.randomBoxTimer,
                  ),
                );
                add(MainScreenFreeze(flag: false, data: event.data));
              },
            ),
          );
        },
      ),
    );
  }
  _hasAnimation(IngredientType ingredientType) =>
      IngredientType.coin != ingredientType &&
      IngredientType.randomScratchSingle != ingredientType &&
      IngredientType.randomScratchMulti != ingredientType;
}
