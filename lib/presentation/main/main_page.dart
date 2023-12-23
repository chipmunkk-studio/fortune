import 'dart:async';
import 'dart:io';

import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fortune/core/error/failure/network_failure.dart';
import 'package:fortune/core/fortune_ext.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/core/notification/notification_response.dart';
import 'package:fortune/core/util/adhelper.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/core/util/mixpanel.dart';
import 'package:fortune/core/util/toast.dart';
import 'package:fortune/core/widgets/bottomsheet/bottom_sheet_ext.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/di.dart';
import 'package:fortune/env.dart';
import 'package:fortune/presentation/giftbox/giftbox_action_param.dart';
import 'package:fortune/presentation/giftbox/giftbox_action_response.dart';
import 'package:fortune/presentation/ingredientaction/ingredient_action_param.dart';
import 'package:fortune/presentation/ingredientaction/ingredient_action_response.dart';
import 'package:fortune/presentation/main/component/map/main_location_data.dart';
import 'package:fortune/presentation/missions/missions_bottom_contents.dart';
import 'package:fortune/presentation/missions/missions_top_contents.dart';
import 'package:fortune/presentation/myingredients/my_ingredients_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:upgrader/upgrader.dart';
import 'package:vungle/vungle.dart';

import 'bloc/main.dart';
import 'component/map/main_map.dart';
import 'component/map/random_box_widget.dart';
import 'component/notice/top_information_area.dart';
import 'component/notice/top_location_area.dart';
import 'component/notice/top_notice.dart';
import 'main_ext.dart';

class MainPage extends StatelessWidget {
  final FortuneNotificationEntity? notificationEntity;

  const MainPage(
    this.notificationEntity, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<MainBloc>()..add(MainInit(notificationEntity: notificationEntity)),
      child: const _MainPage(),
    );
  }
}

class _MainPage extends StatefulWidget {
  const _MainPage();

  @override
  State<_MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<_MainPage> with WidgetsBindingObserver, TickerProviderStateMixin, RouteAware {
  final MapController _mapController = MapController();
  late MainBloc _bloc;
  final GlobalKey<CartIconKey> _cartKey = GlobalKey<CartIconKey>();
  final FortuneRemoteConfig _remoteConfig = serviceLocator<Environment>().remoteConfig;
  final _router = serviceLocator<FortuneAppRouter>().router;
  late StreamSubscription<Position> _locationChangeSubscription;
  late StreamSubscription<CompassEvent>? _rotateChangeEvent;
  late Function(GlobalKey) _runAddToCartAnimation;
  final MixpanelTracker _tracker = serviceLocator<MixpanelTracker>();
  Position? _myLocation;
  bool _detectPermission = false;
  final FToast _fToast = FToast();
  final _routeObserver = serviceLocator<RouteObserver<PageRoute>>();

  late AnimationController _centerRotateController;
  DateTime? lastPressed;
  int _rewardedAdRetryAttempt = 1;

  Timer? _giftBoxTimer;
  Timer? _coinBoxTimer;

  @override
  void initState() {
    super.initState();
    _fToast.init(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
    });
    WidgetsBinding.instance.addObserver(this);
    _bloc = BlocProvider.of<MainBloc>(context);
    _loadRewardedAd(_remoteConfig.adRequestIntervalTime);
    _initVungleAd();
    _listeningLocationChange();
    _initAnimationController();
  }

  _initAnimationController() {
    _centerRotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
  }

  _initVungleAd() {
    Vungle.init(VungleAdHelper.appKey);
    Vungle.onInitilizeListener = () {
      Vungle.onAdPlayableListener = (playable, placementId) async {
        if (!placementId) {
          await Future.delayed(const Duration(seconds: 3));
          Vungle.loadAd(VungleAdHelper.rewardedAdUnitId);
        } else {
          FortuneLogger.info('Vungle:: Load Success');
        }
      };
    };
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _locationChangeSubscription.cancel();
    _rotateChangeEvent?.cancel();
    _routeObserver.unsubscribe(this);
    _centerRotateController.dispose();
    _bloc.close();
  }

  @override
  void didPushNext() {
    super.didPushNext();
    _locationChangeSubscription.pause();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _locationChangeSubscription.resume();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    try {
      switch (state) {
        case AppLifecycleState.resumed:
          PermissionStatus status = await Permission.location.status;
          if (_detectPermission) {
            if (!status.isGranted) {
              _bloc.add(MainInit());
              _detectPermission = false;
            } else {
              _bloc.add(Main());
              _detectPermission = false;
            }
          }
          break;
        case AppLifecycleState.paused:
          PermissionStatus status = await Permission.location.status;
          if (!status.isGranted) {
            _detectPermission = true;
          }
          break;
        default:
          break;
      }
    } catch (e) {
      // 에러무시.
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<MainBloc, MainSideEffect>(
      listener: (context, sideEffect) async {
        if (sideEffect is MainLocationChangeListenSideEffect) {
          // 내 위치 잡고 최초에 한번만 다시 그림.
          if (_myLocation == null) {
            setState(() {
              _myLocation = sideEffect.myLocation;
              _listenRotate(sideEffect.myLocation);
            });
          }
        } else if (sideEffect is MainMarkerObtainSuccessSideEffect) {
          () async {
            if (sideEffect.hasAnimation) {
              await _startAnimation(sideEffect.key);
            }
            _fToast.showToast(
              child: fortuneToastContent(
                icon: Assets.icons.icCheckCircleFill24.svg(),
                content: FortuneTr.msgObtainMarkerSuccess(sideEffect.data.ingredient.exposureName),
              ),
              positionedToastBuilder: (context, child) => Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: child,
              ),
              toastDuration: const Duration(seconds: 2),
            );
          }();
        } else if (sideEffect is MainRequireLocationPermission) {
          dialogService.showFortuneDialog(
            context,
            title: FortuneTr.msgRequirePermissionLocation,
            subTitle: FortuneTr.msgRequirePermissionLocationContent,
            btnOkText: FortuneTr.move,
            btnOkPressed: () {
              openAppSettings();
            },
          );
        } else if (sideEffect is MainError) {
          dialogService.showAppErrorDialog(context, sideEffect.error);
          if (sideEffect.error is NetworkFailure) {
            _bloc.add(Main());
          }
        } else if (sideEffect is MainRequireInCircleMeters) {
          _fToast.showToast(
            child: fortuneToastContent(
              icon: Assets.icons.icWarningCircle24.svg(),
              content: FortuneTr.msgRequireMarkerObtainDistance(
                sideEffect.meters.toStringAsFixed(1),
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
        } else if (sideEffect is MainShowObtainDialog) {
          _showObtainIngredientDialog(sideEffect);
        } else if (sideEffect is MainSchemeLandingPage) {
          _router.navigateTo(
            context,
            sideEffect.landingRoute,
            routeSettings: RouteSettings(
              arguments: MainLandingArgs(
                text: sideEffect.searchText,
              ),
            ),
          );
        } else if (sideEffect is MainShowAppUpdate) {
          if (sideEffect.entity.isForceUpdate) {
            dialogService.showFortuneDialog(
              context,
              title: FortuneTr.msgUpdateTitle,
              subTitle: FortuneTr.msgUpdateMessage,
              btnOkText: FortuneTr.confirm,
              btnOkPressed: () {
                launchStore(() {
                  _bloc.add(MainInit());
                });
              },
            );
          } else {
            dialogService.showFortuneDialog(
              context,
              title: sideEffect.entity.title,
              subTitle: sideEffect.entity.content,
              btnOkText: FortuneTr.confirm,
              btnOkPressed: () => sideEffect.entity.isAlert ? null : _bloc.add(MainInit()),
            );
          }
        } else if (sideEffect is MainRotateEffect) {
          _animateCameraRotate(sideEffect.prevData, sideEffect.nextData);
        } else if (sideEffect is MainRequiredTicket) {
          dialogService.showFortuneDialog(
            context,
            subTitle: FortuneTr.requireMoreTicket(sideEffect.requiredTicket.toString()),
            dismissOnTouchOutside: false,
            dismissOnBackKeyPress: false,
            btnOkPressed: () {},
          );
        } else if (sideEffect is MainNavigateOpenRandomBox) {
          _openRandomBox(sideEffect);
        }
      },
      child: FortuneScaffold(
        padding: EdgeInsets.zero,
        child: UpgradeAlert(
          upgrader: Upgrader(
            dialogStyle: Platform.isIOS ? UpgradeDialogStyle.cupertino : UpgradeDialogStyle.material,
            durationUntilAlertAgain: const Duration(days: 1),
            canDismissDialog: true,
            shouldPopScope: () => true,
          ),
          child: WillPopScope(
            onWillPop: () async {
              final now = DateTime.now();
              bool backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
                  lastPressed == null || now.difference(lastPressed!) > const Duration(seconds: 2);
              if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
                _fToast.showToast(
                  child: fortuneToastContent(
                    content: FortuneTr.msgPressAgainToExit,
                  ),
                  positionedToastBuilder: (context, child) => Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: child,
                  ),
                  toastDuration: const Duration(seconds: 2),
                );
                lastPressed = DateTime.now();
                return false;
              }
              return true;
            },
            child: Stack(
              children: [
                // 메인 맵.
                MainMap(
                  _bloc,
                  mainContext: context,
                  remoteConfigArgs: _remoteConfig,
                  mapController: _mapController,
                  centerRotateController: _centerRotateController,
                  myLocation: _myLocation,
                  onZoomChanged: () {
                    _animatedMapMove(
                      LatLng(
                        _bloc.state.myLocation!.latitude,
                        _bloc.state.myLocation!.longitude,
                      ),
                      _bloc.state.zoomThreshold,
                    );
                    _bloc.add(Main());
                  },
                ),
                // 카트.
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Bounceable(
                    onTap: _onMyBagClick,
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorName.grey700,
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Assets.icons.icInventory.svg(),
                      ),
                    ),
                  ),
                ),
                AddToCartAnimation(
                  cartKey: _cartKey,
                  opacity: 0.85,
                  dragAnimation: const DragToCartAnimationOptions(
                    rotation: true,
                  ),
                  jumpAnimation: const JumpAnimationOptions(),
                  createAddToCartAnimation: (runAddToCartAnimation) {
                    _runAddToCartAnimation = runAddToCartAnimation;
                  },
                  child: Positioned(
                    top: 13,
                    right: 20,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        BlocBuilder<MainBloc, MainState>(
                          buildWhen: (previous, current) => previous.hasNewAlarm != current.hasNewAlarm,
                          builder: (context, state) {
                            return TopLocationArea(
                              hasNewAlarm: state.hasNewAlarm,
                              onProfileTap: () {
                                _tracker.trackEvent('메인_프로필_클릭');
                                _router.navigateTo(
                                  context,
                                  AppRoutes.myPageRoute,
                                );
                              },
                              onHistoryTap: () {
                                _tracker.trackEvent('메인_히스토리_클릭');
                                _router.navigateTo(
                                  context,
                                  AppRoutes.obtainHistoryRoute,
                                );
                              },
                              onAlarmClick: () {
                                _tracker.trackEvent('메인_알림_클릭');
                                if (state.hasNewAlarm) {
                                  _bloc.add(MainAlarmRead());
                                }
                                _router.navigateTo(
                                  context,
                                  AppRoutes.alarmFeedRoute,
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        TopNotice(
                          onTap: () {},
                        ),
                        const SizedBox(height: 10),
                        TopInformationArea(
                          _cartKey,
                          onInventoryTap: () {
                            _tracker.trackEvent('메인_인벤토리_클릭');
                            _locationChangeSubscription.pause();
                            context
                                .showBottomSheet(
                                  isDismissible: true,
                                  content: (context) => const MyIngredientsPage(),
                                )
                                .then((value) => _locationChangeSubscription.resume());
                          },
                          onGradeAreaTap: () {
                            _tracker.trackEvent('메인_레벨_클릭');
                            _router.navigateTo(context, AppRoutes.rankingRoutes);
                          },
                          onCoinTap: _showCoinDialog,
                        ),
                        BlocConsumer<MainBloc, MainState>(
                          listenWhen: (previous, current) =>
                              previous.isLoading != current.isLoading ||
                              previous.giftBoxTimerSecond != current.giftBoxTimerSecond,
                          listener: (context, state) {
                            _giftBoxTimer?.cancel();
                            if (!state.giftBoxOpenable) {
                              _giftBoxTimer = Timer.periodic(const Duration(seconds: 1), (_) {
                                final newSeconds = state.giftBoxTimerSecond - 1;
                                if (newSeconds <= 0) {
                                  _giftBoxTimer?.cancel();
                                }
                                _bloc.add(MainRandomBoxTimerCount(newSeconds, type: GiftboxType.random));
                              });
                            }
                          },
                          buildWhen: (previous, current) =>
                              previous.isLoading != current.isLoading ||
                              previous.giftBoxTimerSecond != current.giftBoxTimerSecond,
                          builder: (context, state) {
                            return BlocBuilder<MainBloc, MainState>(
                              buildWhen: (previous, current) =>
                                  previous.giftBoxTimerSecond != current.giftBoxTimerSecond ||
                                  previous.isLoading != current.isLoading,
                              builder: (context, state) {
                                return state.isLoading
                                    ? const SizedBox.shrink()
                                    : RandomBoxWidget(
                                        _bloc,
                                        timerSeccond: state.giftBoxTimerSecond,
                                        isOpenable: state.giftBoxOpenable,
                                        type: GiftboxType.random,
                                      );
                              },
                            );
                          },
                        ),
                        BlocConsumer<MainBloc, MainState>(
                          listenWhen: (previous, current) =>
                              previous.isLoading != current.isLoading ||
                              previous.coinBoxTimerSecond != current.coinBoxTimerSecond,
                          listener: (context, state) {
                            _coinBoxTimer?.cancel();
                            if (!state.coinBoxOpenable) {
                              _coinBoxTimer = Timer.periodic(const Duration(seconds: 1), (_) {
                                final newSeconds = state.coinBoxTimerSecond - 1;
                                if (newSeconds <= 0) {
                                  _coinBoxTimer?.cancel();
                                }
                                _bloc.add(MainRandomBoxTimerCount(newSeconds, type: GiftboxType.coin));
                              });
                            }
                          },
                          buildWhen: (previous, current) =>
                              previous.isLoading != current.isLoading ||
                              previous.coinBoxTimerSecond != current.coinBoxTimerSecond,
                          builder: (context, state) {
                            return BlocBuilder<MainBloc, MainState>(
                              buildWhen: (previous, current) =>
                                  previous.coinBoxTimerSecond != current.coinBoxTimerSecond ||
                                  previous.isLoading != current.isLoading,
                              builder: (context, state) {
                                return state.isLoading
                                    ? const SizedBox.shrink()
                                    : RandomBoxWidget(
                                        _bloc,
                                        timerSeccond: state.coinBoxTimerSecond,
                                        isOpenable: state.coinBoxOpenable,
                                        type: GiftboxType.coin,
                                      );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // 하단 그라데이션.
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 24,
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
                // 상단 그라데이션.
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
                          ColorName.grey900.withOpacity(0.0),
                          ColorName.grey900.withOpacity(1.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// 위치변경감지.
  Future<StreamSubscription<Position>> listenLocationChange() async {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: mapLocationAccuracy),
    ).listen((Position? position) {
      _animatedMapMove(
        LatLng(
          position!.latitude,
          position.longitude,
        ),
        _bloc.state.zoomThreshold,
        newLoc: position,
      );
    });
  }

// 카메라 이동 애니메이션.
  void _animatedMapMove(
    LatLng destLocation,
    double destZoom, {
    Position? newLoc,
  }) {
    try {
      final latTween = Tween<double>(begin: _mapController.camera.center.latitude, end: destLocation.latitude);
      final lngTween = Tween<double>(begin: _mapController.camera.center.longitude, end: destLocation.longitude);
      final zoomTween = Tween<double>(begin: _mapController.camera.zoom, end: destZoom);

      final controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
      final Animation<double> animation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

      controller.addListener(() {
        try {
          _mapController.move(
            LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
            zoomTween.evaluate(animation),
          );
        } catch (e) {
          // 에러 무시.
        }
      });

      // 애니메이션 후 바로 해제.
      animation.addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            controller.dispose();
          }
        },
      );

      controller.forward();

      if (newLoc != null) {
        _bloc
          ..add(MainMyLocationChange(newLoc))
          ..add(Main());
      }
    } catch (e) {
      FortuneLogger.error(message: e.toString());
    }
  }

  _animateCameraRotate(
    double prevData,
    double nextData,
  ) {
    final controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    final rotationTween = Tween<double>(
      begin: prevData,
      end: nextData,
    );

    final Animation<double> animation = rotationTween.animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.fastEaseInToSlowEaseOut,
      ),
    );

    controller.addListener(() {
      try {
        _mapController.rotate(animation.value);
      } catch (e) {
        // 에러 처리
      }
    });

    animation.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          controller.dispose();
        }
      },
    );
    controller.forward();
  }

// 광고 로드
  void _loadRewardedAd(int adRequestIntervalTime) async {
    try {
      RewardedAd.load(
        adUnitId: GoogleAdHelper.rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardedAdRetryAttempt = 1;
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
                _bloc.add(MainSetRewardAd(null));
                _loadRewardedAd(adRequestIntervalTime);
              },
              onAdShowedFullScreenContent: (ad) {
                _bloc.add(MainSetRewardAd(null));
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                ad.dispose();
                _bloc.add(MainSetRewardAd(null));
                _loadRewardedAd(adRequestIntervalTime);
              },
            );
            FortuneLogger.info("광고 로딩 성공");
            _bloc.add(MainSetRewardAd(ad));
          },
          onAdFailedToLoad: (err) async {
            try {
              await Future.delayed(Duration(milliseconds: adRequestIntervalTime * _rewardedAdRetryAttempt++));
              _loadRewardedAd(adRequestIntervalTime);
              _bloc.add(MainSetRewardAd(null));
              FortuneLogger.error(message: "광고 로딩 실패 : $err");
            } catch (e) {
              _bloc.add(MainSetRewardAd(null));
            }
          },
        ),
      );
    } catch (e) {
      FortuneLogger.error(message: "광고 로딩 실패: $e}");
      _bloc.add(MainSetRewardAd(null));
    }
  }

  _showObtainIngredientDialog(MainShowObtainDialog param) {
    final ingredient = param.data.ingredient;

    String dialogSubtitle = () {
      if (ingredient.type == IngredientType.coin) {
        return param.isShowAd ? FortuneTr.msgWatchAd : FortuneTr.msgAcquireCoin;
      } else {
        return FortuneTr.msgConsumeCoinToGetMarker(ingredient.rewardTicket.abs().toString());
      }
    }();

    dialogService.showFortuneDialog(
      context,
      subTitle: dialogSubtitle,
      btnOkText: FortuneTr.confirm,
      btnCancelText: FortuneTr.cancel,
      dismissOnBackKeyPress: true,
      dismissOnTouchOutside: true,
      onDismissCallback: (_) => _bloc.add(MainScreenFreeze(flag: false, data: param.data)),
      btnCancelPressed: () => _bloc.add(MainScreenFreeze(flag: false, data: param.data)),
      btnOkPressed: () async => _handleOkPressed(context, param),
    );
  }

  Future<void> _handleOkPressed(
    BuildContext context,
    MainShowObtainDialog param,
  ) async {
    final IngredientActionResponse? response = await _router.navigateTo(
      context,
      AppRoutes.ingredientActionRoute,
      routeSettings: RouteSettings(
        arguments: IngredientActionParam(
          ingredient: param.data.ingredient,
          ad: param.ad,
          user: param.user,
          isShowAd: param.isShowAd,
        ),
      ),
    );

    if (response != null) {
      _processIngredientActionReturn(
        param.data,
        param.key,
        response,
      );
    }
  }

  _processIngredientActionReturn(
    MainLocationData data,
    GlobalKey key,
    IngredientActionResponse response,
  ) {
    if (response is NoAds) {
      _showIngredientActionReturnToast(FortuneTr.msgNoAdsAvailable);
    } else if (response is ObtainSuccess) {
      _bloc.add(
        MainMarkerObtain(
          data: data.copyWith(ingredient: response.ingredient),
          key: key,
        ),
      );
    } else if (response is ScratchCancel) {
    } else {
      // 나머지 케이스.
    }
  }

  // 광고가 없을 경우 토스트 노출.
  void _showIngredientActionReturnToast(String text) {
    _fToast.showToast(
      child: fortuneToastContent(
        icon: Assets.icons.icWarningCircle24.svg(),
        content: text,
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

  // 마커 트랜지션.
  _startAnimation(GlobalKey key) async {
    try {
      await _runAddToCartAnimation(key);
      await _cartKey.currentState!.runCartAnimation();
    } catch (e) {
      // do nothing.
    }
  }

  // 가방 클릭
  _onMyBagClick() {
    // 열었을때 중지.
    _locationChangeSubscription.pause();
    context
        .showFullBottomSheet(
          heightFactor: 0.93,
          topContent: (context) => const MissionsTopContents(),
          scrollContent: (context) => MissionsBottomContents(_bloc),
        )
        .then(
          // 닫았을때 재개.
          (value) => _locationChangeSubscription.resume(),
        );
  }

  // 코인 클릭.
  _showCoinDialog() => dialogService.showFortuneDialog(
        context,
        dismissOnTouchOutside: true,
        dismissOnBackKeyPress: true,
        btnOkText: FortuneTr.confirm,
        btnOkPressed: () {},
        subTitle: FortuneTr.msgCollectWithCoin,
      );

  // 회전감지
  _listenRotate(Position myLocation) {
    _rotateChangeEvent = FlutterCompass.events?.listen((data) {
      _bloc.add(MainMapRotate(data));
    });
  }

  _listeningLocationChange() async {
    _locationChangeSubscription = await listenLocationChange();
  }

  void _openRandomBox(MainNavigateOpenRandomBox sideEffect) async {
    final markerData = sideEffect.data;
    final GiftboxActionResponse? actionResponse = await _router.navigateTo(
      context,
      AppRoutes.giftBoxActionRoute,
      routeSettings: RouteSettings(
        arguments: GiftboxActionParam(
          ad: sideEffect.ad,
          ingredient: markerData.ingredient,
          user: sideEffect.user,
          giftType: sideEffect.type,
        ),
      ),
    );
    if (actionResponse != null) {
      _bloc.add(
        MainMarkerObtainFromRandomBox(
          markerData.copyWith(
            ingredient: actionResponse.ingredient,
          ),
          type: sideEffect.type,
        ),
      );
    } else {
      _bloc.add(MainMarkerObtainFromRandomBoxCancel(sideEffect.type));
    }
  }
}
