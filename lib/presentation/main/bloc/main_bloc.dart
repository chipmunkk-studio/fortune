import 'dart:async';
import 'dart:convert';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/error/fortune_error_mapper.dart';
import 'package:foresh_flutter/core/network/credential/user_credential.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/core/util/permission.dart';
import 'package:foresh_flutter/domain/usecases/click_marker_usecase.dart';
import 'package:foresh_flutter/domain/usecases/main_usecase.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/environment.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:single_item_storage/storage.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../component/map/main_changed_location_data.dart';
import '../component/map/main_location_data.dart';
import 'main.dart';

class MainBloc extends Bloc<MainEvent, MainState> with SideEffectBlocMixin<MainEvent, MainState, MainSideEffect> {
  static const tag = "[CountryCodeBloc]";

  final MainUseCase mainUseCase;
  final ClickMarkerUseCase clickMarkerUseCase;
  final Storage<UserCredential> userStorage;
  late StompClient _stompClient;

  MainBloc({
    required this.mainUseCase,
    required this.clickMarkerUseCase,
    required this.userStorage,
  }) : super(MainState.initial()) {
    on<MainInit>(init);
    on<MainGetLocation>(getLocation);
    on<MainMyLocationChange>(locationChange);
    on<MainMarkerClick>(
      onMarkerClicked,
      transformer: sequential(),
    );
    on<MainMarkerLocationChange>(markerLocationChange);
    on<MainChangeNewMarkers>(
      changeNewMarkers,
      transformer: sequential(),
    );
    on<MainRefreshNotice>(refreshNotice);
  }

  FutureOr<void> init(MainInit event, Emitter<MainState> emit) async {
    bool hasPermission = await FortunePermissionUtil().requestPermission([Permission.location]);
    // 위치 권한이 없을 경우.
    if (!hasPermission) {
      produceSideEffect(MainRequireLocationPermission());
      return;
    }
    add(MainGetLocation());
  }

  // 위치 정보 초기화.
  FutureOr<void> getLocation(MainGetLocation event, Emitter<MainState> emit) async {
    Location location = Location();
    LocationData locationData = await location.getLocation();

    // #1 내 위치먼저 찍음.
    emit(state.copyWith(myLocation: locationData));

    // #1-1 카메라 센터를 내 현재위치로 변경.
    produceSideEffect(MainLocationChangeListenSideEffect(location, locationData));

    // #2 API 받아서 위치 뿌려줌.
    await mainUseCase(
      RequestMainParams(
        latitude: locationData.latitude,
        longitude: locationData.longitude,
      ),
    ).then(
      (value) => value.fold(
        // 실패시 에러 처리.
        (l) => produceSideEffect(MainError(l)),
        (r) async {
          try {
            UserCredential? credential = await userStorage.get();
            UserCredential user = await userStorage.save(credential!.copy(id: r.id));
            emit(
              state.copyWith(
                userId: user.id!,
                markers: r.markers
                    .map(
                      (e) => MainLocationData(
                        id: e.id,
                        location: LatLng(e.latitude, e.longitude),
                        disappeared: false,
                        grade: e.grade,
                      ),
                    )
                    .toList(),
                notices: r.histories,
                profileImage: r.profileImageUrl,
                normalTicketCnt: r.normalTicketsCnt,
                chargeTicketCnt: r.chargeTicketCnt,
                roundTime: r.roundTime,
              ),
            );
          } catch (e) {
            produceSideEffect(MainError(AuthFailure.internal(errorMessage: e.toString())));
          }
        },
      ),
    );

    // #3 소켓연결해서 리스트 변경 감지.
    _connectSocket();
  }

  // 위치 변경 시.
  FutureOr<void> locationChange(MainMyLocationChange event, Emitter<MainState> emit) async {
    emit(
      state.copyWith(
        myLocation: event.newLoc,
      ),
    );
  }

  // 마커 클릭 시.
  FutureOr<void> onMarkerClicked(MainMarkerClick event, Emitter<MainState> emit) async {
    await clickMarkerUseCase(
      RequestPostMarkerParams(
        id: event.id,
        latitude: event.latitude,
        longitude: event.longitude,
      ),
    ).then(
      (value) => value.fold(
        (l) {
          if (l.code == FortuneErrorStatus.markerAlreadyAcquired) {
            List<MainLocationData> newList = List.from(state.markers);
            var loc = state.markers.firstWhereOrNull((element) {
              return element.location.longitude == event.longitude && element.location.latitude == event.latitude;
            });
            newList.remove(loc);
            add(MainChangeNewMarkers(newList));
          }
          produceSideEffect(MainError(l));
        },
        (r) {
          emit(
            state.copyWith(
              chargeTicketCnt: r.chargedTickets,
              normalTicketCnt: r.normalTickets,
              isNewMarker: r.isNew,
            ),
          );
        },
      ),
    );
    // if (event.distance < 0) {
    //   await clickMarkerUseCase(
    //     RequestPostMarkerParams(
    //       id: event.id,
    //       latitude: event.latitude,
    //       longitude: event.longitude,
    //     ),
    //   ).then(
    //     (value) => value.fold(
    //       // 획득 실패 시.
    //       (l) => produceSideEffect(MainError(l)),
    //       (r) {},
    //     ),
    //   );
    // } else {
    //   produceSideEffect(MainRequireInCircleMeters(event.distance));
    // }
  }

  // 소켓 연결.
  void _connectSocket() {
    final url = serviceLocator<Environment>().configArgs.baseUrl;
    _stompClient = StompClient(
      config: StompConfig(
        url: 'ws://ec2-15-164-228-218.ap-northeast-2.compute.amazonaws.com:10083/fortune',
        onConnect: onConnect,
        beforeConnect: () async {
          FortuneLogger.debug('소켓 연결중.....');
        },
        onWebSocketError: (dynamic error) => FortuneLogger.debug(error.toString()),
        stompConnectHeaders: {'Authorization': 'Bearer yourToken'},
        webSocketConnectHeaders: {'Authorization': 'Bearer yourToken'},
      ),
    );
    _stompClient.activate();
  }

  // 연결 성공했을 경우.
  void onConnect(StompFrame frame) {
    _stompClient.subscribe(
      destination: '/topic/marker',
      headers: {},
      callback: (callback) {
        var locationInfoBody = callback.body;
        FortuneLogger.debug("locationInfoBody:$locationInfoBody");
        if (locationInfoBody != null) {
          MainChangedLocationData l = MainChangedLocationData.fromJson(jsonDecode(locationInfoBody));
          add(MainMarkerLocationChange(l.id, l.latitude, l.longitude, l.userId, l.nickname));
        }
      },
    );
  }

  // 마커 위치 변경.
  FutureOr<void> markerLocationChange(MainMarkerLocationChange event, Emitter<MainState> emit) async {
    late List<MainLocationData> newMarkers;
    // 내가 클릭한 위치여부.
    bool isAnotherLocation = state.userId != event.userId;

    if (isAnotherLocation) {
      // 기존 위치 파티클 효과.
      newMarkers = state.markers.map((e) {
        if (e.id == event.id) {
          return MainLocationData(
            id: e.id,
            location: e.location,
            disappeared: true,
          );
        } else {
          return e;
        }
      }).toList();
      // 다음 위치 추가.
      newMarkers.add(
        MainLocationData(
          id: event.id,
          location: LatLng(event.latitude, event.longitude),
          disappeared: false,
        ),
      );
      add(MainChangeNewMarkers(newMarkers));
    } else {
      // 내가 클릭한 위치라면.
      final marker = state.markers.firstWhere((element) => element.id == event.id);
      newMarkers = state.markers.map((e) {
        if (e.id == event.id) {
          return MainLocationData(
            id: e.id,
            location: LatLng(event.latitude, event.longitude),
            disappeared: false,
          );
        } else {
          return e;
        }
      }).toList();
      produceSideEffect(
        MainMarkerClickSideEffect(
          key: marker.widgetKey,
          grade: marker.grade,
          newMarkers: newMarkers,
        ),
      );
    }
  }

  FutureOr<void> changeNewMarkers(MainChangeNewMarkers event, Emitter<MainState> emit) {
    emit(state.copyWith(markers: event.newMarkers));
  }

  FutureOr<void> refreshNotice(MainRefreshNotice event, Emitter<MainState> emit) {
    // todo 마커리프레시 목록은 어떻게 가져오는지?
    emit(
      state.copyWith(
        notices: state.notices,
      ),
    );
  }
}
