import 'dart:async';

import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fortune/core/error/failure/network_failure.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/notification/notification_response.dart';
import 'package:fortune/core/util/adhelper.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/util/toast.dart';
import 'package:fortune/core/widgets/bottomsheet/bottom_sheet_ext.dart';
import 'package:fortune/core/widgets/button/fortune_text_button.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/data/supabase/service/service_ext.dart';
import 'package:fortune/di.dart';
import 'package:fortune/env.dart';
import 'package:fortune/fortune_router.dart';
import 'package:fortune/presentation/ingredientaction/ingredient_action_page.dart';
import 'package:fortune/presentation/login/bloc/login_state.dart';
import 'package:fortune/presentation/missions/missions_bottom_page.dart';
import 'package:fortune/presentation/myingredients/my_ingredients_page.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' show Location, LocationData;
import 'package:permission_handler/permission_handler.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:upgrader/upgrader.dart';

import 'bloc/main.dart';
import 'component/map/main_location_data.dart';
import 'component/map/main_map.dart';
import 'component/notice/top_information_area.dart';
import 'component/notice/top_location_area.dart';
import 'component/notice/top_notice.dart';
import 'main_ext.dart';

class MainPage extends StatelessWidget {
  final FortuneNotificationEntity? notificationEntity;

  const MainPage(
    this.notificationEntity, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      child: BlocProvider(
        create: (_) => serviceLocator<MainBloc>()
          ..add(
            MainInit(
              notificationEntity: notificationEntity,
            ),
          ),
        child: const _MainPage(),
      ),
    );
  }
}

class _MainPage extends StatefulWidget {
  const _MainPage({Key? key}) : super(key: key);

  @override
  State<_MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<_MainPage> with WidgetsBindingObserver, TickerProviderStateMixin {
  final MapController _mapController = MapController();
  late MainBloc _bloc;
  final GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  final FortuneRemoteConfig environment = serviceLocator<Environment>().remoteConfig;
  final router = serviceLocator<FortuneRouter>().router;
  late StreamSubscription<LocationData> locationChangeSubscription;
  late Function(GlobalKey) runAddToCartAnimation;
  LocationData? myLocation;
  bool _detectPermission = false;
  FToast fToast = FToast();

  @override
  void initState() {
    super.initState();
    fToast.init(context);
    WidgetsBinding.instance.addObserver(this);
    _bloc = BlocProvider.of<MainBloc>(context);
    _loadRewardedAd();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    locationChangeSubscription.cancel();
    _bloc.close();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
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
        } else {
          _bloc.add(Main());
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<MainBloc, MainSideEffect>(
      listener: (context, sideEffect) async {
        if (sideEffect is MainLocationChangeListenSideEffect) {
          locationChangeSubscription = await listenLocationChange(sideEffect.myLocation);
          // 내 위치 잡고 최초에 한번만 다시 그림.
          if (myLocation == null) {
            setState(() {
              myLocation = sideEffect.myLocationData;
            });
          }
        } else if (sideEffect is MainMarkerObtainSuccessSideEffect) {
          () async {
            if (sideEffect.isAnimation) {
              await _startAnimation(sideEffect.key);
            }
            fToast.showToast(
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
          dialogService.showErrorDialog(context, sideEffect.error);
          if (sideEffect.error is NetworkFailure) {
            _bloc.add(Main());
          }
        } else if (sideEffect is MainRequireInCircleMeters) {
          fToast.showToast(
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
          _showObtainIngredientDialog(
            sideEffect.data,
            sideEffect.key,
            sideEffect.isShowAd,
          );
        } else if (sideEffect is MainSchemeLandingPage) {
          router.navigateTo(
            context,
            sideEffect.landingRoute,
            routeSettings: RouteSettings(
              arguments: MainLandingArgs(
                text: sideEffect.searchText,
              ),
            ),
          );
        }
      },
      child: FortuneScaffold(
        padding: EdgeInsets.zero,
        child: Stack(
          children: [
            // 메인 맵.
            MainMap(
              _bloc,
              router: router,
              context: context,
              remoteConfigArgs: environment,
              mapController: _mapController,
              myLocation: myLocation,
              onZoomChanged: () {
                _animatedMapMove(
                  LatLng(
                    _bloc.state.myLocation!.latitude!,
                    _bloc.state.myLocation!.longitude!,
                  ),
                  _bloc.state.zoomThreshold,
                );
                _bloc.add(Main());
              },
            ),
            // 카트.
            Positioned(
              bottom: 8,
              right: 8,
              child: GestureDetector(
                onTap: _onMyBagClick,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: ColorName.grey800,
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Assets.icons.icInventory.svg(),
                  ),
                ),
              ),
            ),
            AddToCartAnimation(
              cartKey: cartKey,
              opacity: 0.85,
              dragAnimation: const DragToCartAnimationOptions(
                rotation: true,
              ),
              jumpAnimation: const JumpAnimationOptions(),
              createAddToCartAnimation: (runAddToCartAnimation) {
                this.runAddToCartAnimation = runAddToCartAnimation;
              },
              child: Positioned(
                top: 13,
                right: 20,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    TopLocationArea(
                      onProfileTap: () => router.navigateTo(
                        context,
                        Routes.myPageRoute,
                      ),
                      onHistoryTap: () => router.navigateTo(
                        context,
                        Routes.obtainHistoryRoute,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TopNotice(
                      onTap: () {},
                    ),
                    const SizedBox(height: 10),
                    TopInformationArea(
                      cartKey,
                      onInventoryTap: () => context.showFortuneBottomSheet(
                        isDismissible: true,
                        content: (context) => const MyIngredientsPage(),
                      ),
                      onGradeAreaTap: () => router.navigateTo(context, Routes.gradeGuideRoute),
                    ),
                    if (!kReleaseMode) _buildDebugLogout(context),
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
          ],
        ),
      ),
    );
  }

  Align _buildDebugLogout(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FortuneTextButton(
        onPress: () {
          Supabase.instance.client.auth.signOut();
          router.navigateTo(
            context,
            "${Routes.loginRoute}/:${LoginUserState.needToLogin}",
            clearStack: true,
            replace: false,
          );
        },
        text: '로그아웃',
        textStyle: FortuneTextStyle.body3Light(),
      ),
    );
  }

  // 위치변경감지.
  Future<StreamSubscription<LocationData>> listenLocationChange(Location myLocation) async {
    return myLocation.onLocationChanged.listen(
      (newLoc) {
        _animatedMapMove(
          LatLng(
            newLoc.latitude!,
            newLoc.longitude!,
          ),
          _bloc.state.zoomThreshold,
          newLoc: newLoc,
        );
      },
    );
  }

  // 카메라 이동 애니메이션.
  void _animatedMapMove(
    LatLng destLocation,
    double destZoom, {
    LocationData? newLoc,
  }) {
    try {
      final latTween = Tween<double>(begin: _mapController.center.latitude, end: destLocation.latitude);
      final lngTween = Tween<double>(begin: _mapController.center.longitude, end: destLocation.longitude);
      final zoomTween = Tween<double>(begin: _mapController.zoom, end: destZoom);

      final controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
      final Animation<double> animation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

      controller.addListener(() {
        _mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation),
        );
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
        _bloc.add(MainMyLocationChange(newLoc));
      }
    } catch (e) {
      FortuneLogger.error(message: e.toString());
    }
  }

  // 광고 로드
  void _loadRewardedAd() async {
    try {
      RewardedAd.load(
        adUnitId: AdHelper.rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
                _loadRewardedAd();
              },
            );
            FortuneLogger.info("광고 로딩 성공");
            _bloc.add(MainSetRewardAd(ad));
          },
          onAdFailedToLoad: (err) {
            FortuneLogger.error(message: "광고 로딩 실패 #1");
            _loadRewardedAd();
            _bloc.add(MainSetRewardAd(null));
          },
        ),
      );
    } catch (e) {
      FortuneLogger.error(message: "광고 로딩 실패 #2");
      _bloc.add(MainSetRewardAd(null));
    }
  }

  _showObtainIngredientDialog(
    MainLocationData data,
    GlobalKey globalKey,
    bool isShowAd,
  ) {
    String dialogSubtitle = (data.ingredient.type == IngredientType.coin) && isShowAd
        ? FortuneTr.msgWatchAd
        : (data.ingredient.type != IngredientType.coin)
            ? FortuneTr.msgConsumeCoinToGetMarker(
                data.ingredient.rewardTicket.abs().toString(),
              )
            : FortuneTr.msgAcquireCoin;

    dialogService.showFortuneDialog(
      context,
      subTitle: dialogSubtitle,
      btnOkText: FortuneTr.confirm,
      btnCancelText: FortuneTr.cancel,
      dismissOnBackKeyPress: true,
      dismissOnTouchOutside: true,
      onDismissCallback: (type) => _bloc.add(MainScreenFreeze(flag: false, data: data)),
      btnCancelPressed: () => _bloc.add(MainScreenFreeze(flag: false, data: data)),
      btnOkPressed: () async {
        final markerActionResult = await router.navigateTo(
          context,
          Routes.ingredientActionRoute,
          routeSettings: RouteSettings(
            arguments: IngredientActionParam(
              ingredient: data.ingredient,
              ad: _bloc.state.rewardAd,
              user: _bloc.state.user,
              isShowAd: isShowAd,
            ),
          ),
        );
        if (markerActionResult) {
          _bloc.add(MainMarkerObtain(data: data, key: globalKey));
        }
      },
    );
  }

  // 마커 트랜지션.
  _startAnimation(GlobalKey key) async {
    try {
      await runAddToCartAnimation(key);
      await cartKey.currentState!.runCartAnimation();
    } catch (e) {
      // do nothing.
    }
  }

  // 가방 클릭
  _onMyBagClick() {
    context.showFortuneBottomSheet(
      content: (context) => MissionsBottomPage(_bloc),
    );
  }
}
