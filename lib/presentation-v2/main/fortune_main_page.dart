import 'dart:async';
import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/core/notification/notification_response.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/core/util/mixpanel.dart';
import 'package:fortune/core/util/toast.dart';
import 'package:fortune/core/widgets/animation/scale_animation.dart';
import 'package:fortune/core/widgets/fortune_loading_view.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/core/widgets/painter/direction_painter.dart';
import 'package:fortune/core/widgets/painter/fortune_radar_background.dart';
import 'package:fortune/di.dart';
import 'package:fortune/presentation-v2/fortune_ad/fortune_ad_complete_return.dart';
import 'package:fortune/presentation-v2/fortune_ad/fortune_ad_param.dart';
import 'package:fortune/presentation-v2/main/bloc/main.dart';
import 'package:fortune/presentation-v2/obtain/fortune_obtain_param.dart';
import 'package:fortune/presentation-v2/obtain/fortune_obtain_success_return.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:upgrader/upgrader.dart';

import 'component/center_profile.dart';
import 'component/missions_status.dart';
import 'fortune_main_ext.dart';

class FortuneMainPage extends StatelessWidget {
  final FortuneNotificationEntity? notificationEntity;

  const FortuneMainPage({
    super.key,
    this.notificationEntity,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<MainBloc>()
        ..add(
          MainInit(
            notificationEntity: notificationEntity,
          ),
        ),
      child: _FortuneMainPage(notificationEntity),
    );
  }
}

class _FortuneMainPage extends StatefulWidget {
  final FortuneNotificationEntity? notificationEntity;

  const _FortuneMainPage(this.notificationEntity);

  @override
  State<_FortuneMainPage> createState() => _FortuneMainPageState();
}

class _FortuneMainPageState extends State<_FortuneMainPage>
    with WidgetsBindingObserver, TickerProviderStateMixin, RouteAware {
  late final MapController _mapController = MapController();
  late MainBloc _bloc;
  final MixpanelTracker _tracker = serviceLocator<MixpanelTracker>();
  final FluroRouter _router = serviceLocator<FortuneAppRouter>().router;
  final FToast _fToast = FToast();
  final _routeObserver = serviceLocator<RouteObserver<PageRoute>>();

  late StreamSubscription<Position> _locationChangeSubscription;
  late StreamSubscription<CompassEvent>? _rotateChangeEvent;

  DateTime? lastPressed;

  @override
  void didPushNext() {
    super.didPushNext();
    FortuneLogger.info("didPushNext()");
    _locationChangeSubscription.pause();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    FortuneLogger.info("didPopNext()");
    _locationChangeSubscription.resume();
    _bloc.add(MainOnResume());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tracker.trackEvent('메인화면');
    _fToast.init(context);
    _bloc = BlocProvider.of<MainBloc>(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _locationChangeSubscription.cancel();
    _rotateChangeEvent?.cancel();
    _bloc.close();
    _routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        PermissionStatus status = await Permission.location.status;
        if (!status.isGranted) {
          FortuneLogger.error(message: "권한이 없음");
          _router.navigateTo(
            context,
            AppRoutes.requestPermissionRoute,
            clearStack: true,
          );
          return;
        }
        break;
      case AppLifecycleState.detached:
        FortuneLogger.error(message: "detached");
      default:
        break;
    }
  }

  void _handleSideEffect(BuildContext context, MainSideEffect sideEffect) async {
    if (sideEffect is MainError) {
      dialogService2.showAppErrorDialog(
        context,
        sideEffect.error,
        btnOkOnPress: () {
          _bloc.add(MainInit(notificationEntity: widget.notificationEntity));
        },
      );
    } else if (sideEffect is MainLocationChangeListenSideEffect) {
      final isInit = sideEffect.isInitialize;
      if (isInit) {
        _mapController.move(sideEffect.location, 16);
        // 카메라가 줌인 다되고 나서 위치 받아야 됨.
        await Future.delayed(const Duration(seconds: 1));
        _locationChangeSubscription = await _listenLocationChange();
        _rotateChangeEvent = await _listenRotate();

        /// 아래 코드는 이슈의 여지가 있음.
        _routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
      }
      _animatedMapMove(
        destLocation: sideEffect.location,
        destZoom: sideEffect.destZoom,
      );
    } else if (sideEffect is MainRequireLocationPermission) {
      _router.navigateTo(
        context,
        AppRoutes.requestPermissionRoute,
        clearStack: true,
      );
    } else if (sideEffect is MainShowObtainDialog) {
      dialogService2.showFortuneDialog(
        context,
        subTitle: FortuneTr.msgConsumeCoinToGetMarker(sideEffect.marker.cost.abs().toString()),
        btnOkText: FortuneTr.confirm,
        btnCancelText: FortuneTr.cancel,
        dismissOnBackKeyPress: true,
        dismissOnTouchOutside: true,
        onDismissCallback: (_) {},
        btnCancelPressed: () {},
        btnOkPressed: () async {
          final FortuneObtainSuccessReturn? response = await _router.navigateTo(
            context,
            AppRoutes.markerObtainRoute,
            routeSettings: RouteSettings(
              arguments: FortuneObtainParam(
                ts: sideEffect.timestamp,
                marker: sideEffect.marker,
                location: sideEffect.location,
              ),
            ),
          );
          if (response != null) {
            _bloc.add(MainObtainSuccess(response.markerObtainEntity));
          }
        },
      );
    } else if (sideEffect is MainShowAdDialog) {
      dialogService2.showFortuneDialog(
        context,
        subTitle: FortuneTr.msgWatchAd,
        btnOkText: FortuneTr.confirm,
        btnCancelText: FortuneTr.cancel,
        dismissOnBackKeyPress: true,
        dismissOnTouchOutside: true,
        onDismissCallback: (_) {},
        btnCancelPressed: () {},
        btnOkPressed: () async {
          final FortuneAdCompleteReturn? response = await _router.navigateTo(
            context,
            AppRoutes.fortuneAdRoute,
            routeSettings: RouteSettings(
              arguments: FortuneAdParam(
                ts: sideEffect.ts,
                adState: sideEffect.ad,
              ),
            ),
          );
          if (response != null) {
            _bloc.add(
              MainOnAdShowComplete(
                response.user,
                sideEffect.targetMarker,
              ),
            );
          }
        },
      );
    } else if (sideEffect is MainObtainMarker) {
      final FortuneObtainSuccessReturn? response = await _router.navigateTo(
        context,
        AppRoutes.markerObtainRoute,
        routeSettings: RouteSettings(
          arguments: FortuneObtainParam(
            ts: sideEffect.timestamp,
            marker: sideEffect.marker,
            location: sideEffect.location,
          ),
        ),
      );
      if (response != null) {
        _bloc.add(MainObtainSuccess(response.markerObtainEntity));
      }
    }

    /// 거리가 부족 할 경우
    else if (sideEffect is MainRequireInCircleMetersEvent) {
      _fToast.showToast(
        child: fortuneToastContent(
          icon: Assets.icons.icWarningCircle24.svg(),
          content: FortuneTr.msgRequireMarkerObtainDistance(
            sideEffect.distance.toStringAsFixed(1),
          ),
        ),
        positionedToastBuilder: (context, child) => Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: child,
        ),
        toastDuration: const Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<MainBloc, MainSideEffect>(
      listener: (context, sideEffect) {
        _handleSideEffect(context, sideEffect);
      },
      child: UpgradeAlert(
        upgrader: Upgrader(
          dialogStyle: Platform.isIOS ? UpgradeDialogStyle.cupertino : UpgradeDialogStyle.material,
          durationUntilAlertAgain: const Duration(days: 1),
          canDismissDialog: true,
          shouldPopScope: () => true,
        ),
        child: PopScope(
          canPop: false,
          onPopInvoked: (_) async {
            final now = DateTime.now();
            bool isShowExitToast = lastPressed == null || now.difference(lastPressed!) > const Duration(seconds: 2);
            if (isShowExitToast) {
              _fToast.showToast(
                child: fortuneToastContent(content: FortuneTr.msgPressAgainToExit),
                positionedToastBuilder: (context, child) => Positioned(bottom: 40, left: 0, right: 0, child: child),
                toastDuration: const Duration(seconds: 2),
              );
              lastPressed = DateTime.now();
            } else {
              SystemNavigator.pop();
            }
          },
          child: SafeArea(
            bottom: false,
            top: false,
            child: Scaffold(
              body: Stack(
                children: [
                  /// 메인맵.
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _bloc.state.currentLocation,
                      interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.rotate,
                      minZoom: 15,
                      maxZoom: 20,
                      onPositionChanged: (mapPosition, boolHasGesture) {
                        if (boolHasGesture) {
                          _animatedMapMove(
                            destLocation: _bloc.state.cameraLocation,
                            destZoom: _bloc.state.zoomThreshold,
                          );
                        }
                      },
                      onTap: (tapPosition, point) {
                        final isMarkerObtainable = isMarkerInsideCircle(
                          _bloc.state.cameraLocation,
                          point,
                          38,
                        );
                        if (isMarkerObtainable < 0) {
                          // _bloc.state.ad.showAd(() {
                          //   _bloc.add(MainLoadAd());
                          // });
                        }
                      },
                    ),
                    children: [
                      getLayerByMapType(),
                      BlocBuilder<MainBloc, MainState>(
                        buildWhen: (previous, current) => previous.markerList != current.markerList,
                        builder: (context, state) {
                          return MarkerLayer(
                            markers: state.markerList.toMarkerList(
                              (entity) {
                                final cameraPosition = _bloc.state.cameraLocation;
                                LatLng markerPosition = LatLng(entity.latitude, entity.longitude);
                                final double distance = isMarkerInsideCircle(
                                  cameraPosition,
                                  markerPosition,
                                  38,
                                );
                                _bloc.add(MainMarkerClick(entity, distance));
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  /// 백그라운드
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: FortuneRadarBackground(),
                      ),
                    ),
                  ),

                  /// 나침반.
                  Positioned.fill(
                    child: IgnorePointer(
                      child: BlocBuilder<MainBloc, MainState>(
                        buildWhen: (previous, current) => previous.turns != current.turns,
                        builder: (context, state) {
                          return AnimatedRotation(
                            turns: state.turns,
                            duration: const Duration(milliseconds: 250),
                            child: SizedBox.square(
                              dimension: 100,
                              child: CustomPaint(
                                painter: DirectionPainter(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  /// 센터프로필.
                  Center(
                    child: IgnorePointer(
                      child: AvatarGlow(
                        glowColor: ColorName.primary,
                        glowCount: 3,
                        glowRadiusFactor: 1.8,
                        duration: const Duration(seconds: 3),
                        child: ScaleAnimation(
                          child: BlocBuilder<MainBloc, MainState>(
                            buildWhen: (previous, current) =>
                                previous.user.profileImageUrl != current.user.profileImageUrl,
                            builder: (context, state) {
                              return CenterProfile(
                                imageUrl: state.user.profileImageUrl,
                                backgroundColor: ColorName.primary.withOpacity(1.0),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// 하단 그라데이션.
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            ColorName.grey900.withOpacity(1.0),
                            ColorName.grey900.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// 상단 그라데이션.
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            ColorName.grey900.withOpacity(0.5),
                            ColorName.grey900.withOpacity(1.0),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// 로딩뷰.
                  Positioned.fill(
                    child: BlocBuilder<MainBloc, MainState>(
                      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
                      builder: (context, state) {
                        return state.isLoading
                            ? const FortuneScaffold(
                                padding: EdgeInsets.zero,
                                child: Center(
                                  child: FortuneLoadingView(),
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                  ),

                  /// 미션현황
                  Positioned(
                    bottom: 20,
                    right: 16,
                    child: MissionsStatus(
                      onPress: () => _router.navigateTo(context, AppRoutes.missionsRoute),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 카메라 줌 이동.
  _animatedMapMove({
    required LatLng destLocation,
    required double destZoom,
  }) {
    try {
      // 애니메이션 관련 변수 준비
      final camera = _mapController.camera;
      final latTween = Tween<double>(begin: camera.center.latitude, end: destLocation.latitude);
      final lngTween = Tween<double>(begin: camera.center.longitude, end: destLocation.longitude);
      final zoomTween = Tween<double>(begin: camera.zoom, end: destZoom);
      AnimationController controller = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
      Animation<double> animation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

      // 애니메이션 리스너 설정
      controller.addListener(() {
        _mapController.move(
          LatLng(
            latTween.evaluate(animation),
            lngTween.evaluate(animation),
          ),
          zoomTween.evaluate(animation),
        );
      });

      // 애니메이션 상태 리스너 설정
      animation.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.dispose();
        }
      });

      // 애니메이션 시작
      controller.forward().catchError((error) {
        FortuneLogger.error(message: error.toString());
        // 필요한 경우 사용자에게 에러 알림
      });
    } catch (e) {
      FortuneLogger.error(message: e.toString());
    }
  }

  /// 위치변경감지.
  Future<StreamSubscription<Position>> _listenLocationChange() async {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    ).listen(
      (Position? position) {
        if (position != null) {
          _bloc.add(
            MainLocationChange(
              LatLng(
                position.latitude,
                position.longitude,
              ),
            ),
          );
        }
      },
    );
  }

  /// 회전방향감지.
  _listenRotate() async {
    return FlutterCompass.events?.listen((data) {
      _bloc.add(MainCompassRotate(data));
    });
  }
}
