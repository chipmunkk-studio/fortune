import 'dart:async';

import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart' as appmetrica;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/error/failure/network_failure.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/notification/notification_response.dart';
import 'package:fortune/core/util/adhelper.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/core/util/snackbar.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/bottomsheet/bottom_sheet_ext.dart';
import 'package:fortune/core/widgets/button/fortune_text_button.dart';
import 'package:fortune/core/widgets/dialog/default_dialog.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/data/supabase/service/service_ext.dart';
import 'package:fortune/di.dart';
import 'package:fortune/env.dart';
import 'package:fortune/presentation/fortune_router.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    appmetrica.AppMetrica.reportEvent('메인 화면');
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
        } else if (sideEffect is MainMarkerClickSideEffect) {
          () async {
            final ingredientType = sideEffect.data.ingredient.type;
            if (ingredientType != IngredientType.ticket) {
              await startAnimation(sideEffect.key);
            }
          }();
        } else if (sideEffect is MainRequireLocationPermission) {
          FortuneLogger.debug("Permission Denied :$sideEffect");
          context.showFortuneDialog(
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
          context.showSnackBar(
            FortuneTr.msgRequireMarkerObtainDistance(sideEffect.meters.toStringAsFixed(1)),
          );
        } else if (sideEffect is MainShowDialog) {
          context.showFortuneDialog(
            title: sideEffect.title,
            subTitle: sideEffect.subTitle,
            btnOkText: FortuneTr.confirm,
            dismissOnBackKeyPress: true,
            dismissOnTouchOutside: true,
            btnOkPressed: () {},
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
                    ),
                    const SizedBox(height: 16),
                    TopNotice(
                      onTap: () => router.navigateTo(
                        context,
                        Routes.obtainHistoryRoute,
                      ),
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
        );
        _bloc.add(MainMyLocationChange(newLoc));
      },
    );
  }

  // 카메라 이동 애니메이션.
  void _animatedMapMove(LatLng destLocation, double destZoom) {
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
          } else if (status == AnimationStatus.dismissed) {
            controller.dispose();
          }
        },
      );
      controller.forward();
    } catch (e) {
      FortuneLogger.error(message: e.toString());
    }
  }

  // 광고 로드
  void _loadRewardedAd() async {
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
          _bloc.add(MainSetRewardAd(ad));
        },
        onAdFailedToLoad: (err) {
          _loadRewardedAd();
          _bloc.add(MainSetRewardAd(null));
        },
      ),
    );
  }

  // 마커 트랜지션.
  startAnimation(GlobalKey key) async {
    try {
      await runAddToCartAnimation(key);
      await cartKey.currentState!.runCartAnimation();
    } catch (e) {
      // do nothing.
    }
  }

  _onMyBagClick() {
    context.showFortuneBottomSheet(
      content: (context) => MissionsBottomPage(_bloc),
    );
  }
}
