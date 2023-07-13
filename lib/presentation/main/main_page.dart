import 'dart:async';

import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/core/util/snackbar.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/bottomsheet/bottom_sheet_ext.dart';
import 'package:foresh_flutter/core/widgets/dialog/defalut_dialog.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/data/supabase/response/eventnotice/event_notices_response.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/env.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/main/component/notice/top_refresh_time.dart';
import 'package:foresh_flutter/presentation/missions/missions_bottom_page.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' show Location, LocationData;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'bloc/main.dart';
import 'component/map/main_map.dart';
import 'component/notice/top_information_area.dart';
import 'component/notice/top_location_area.dart';
import 'component/notice/top_notice.dart';
import 'main_ext.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<MainBloc>()..add(MainInit()),
      child: const _MainPage(),
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
  late MainBloc bloc;
  final GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  final FortuneRemoteConfig environment = serviceLocator<Environment>().remoteConfig;
  final router = serviceLocator<FortuneRouter>().router;
  late final StreamSubscription<LocationData> locationChangeSubscription;
  late Function(GlobalKey) runAddToCartAnimation;
  LocationData? myLocation;
  bool _detectPermission = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    bloc = BlocProvider.of<MainBloc>(context);
    // 푸시 알람으로 랜딩 할 경우.
    OneSignal.shared.setNotificationOpenedHandler(
      (event) async {
        event;
        try {
          final notificationData = EventNoticesResponse.fromJson(event.notification.additionalData!);
          // 초기화 이슈 때문에 잠깐 딜레이 주고 이동.
          await Future.delayed(const Duration(milliseconds: 1000));
          bloc.add(MainLandingPage(notificationData));
        } catch (e) {
          dialogService.showErrorDialog(context, CommonFailure(errorMessage: '알림피드를 확인해주세요'));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    locationChangeSubscription.cancel();
    bloc.close();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        PermissionStatus status = await Permission.location.status;
        if (_detectPermission) {
          if (!status.isGranted) {
            bloc.add(MainInit());
            _detectPermission = false;
          } else {
            bloc.add(Main());
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
            await startAnimation(
              sideEffect.key,
            );
          }();
        } else if (sideEffect is MainRequireLocationPermission) {
          FortuneLogger.debug("Permission Denied :$sideEffect");
          context.showFortuneDialog(
            title: '권한요청',
            subTitle: '위치 권한이 필요합니다.',
            btnOkText: '이동',
            btnOkPressed: () {
              openAppSettings();
            },
          );
        } else if (sideEffect is MainError) {
          dialogService.showErrorDialog(context, sideEffect.error);
          if (sideEffect.error is NetworkFailure) {
            bloc.add(Main());
          }
        } else if (sideEffect is MainRequireInCircleMeters) {
          context.showSnackBar("거리가 ${sideEffect.meters.toStringAsFixed(1)} 미터 만큼 부족합니다.");
        } else if (sideEffect is MainShowDialog) {
          context.showFortuneDialog(
            title: sideEffect.title,
            subTitle: sideEffect.subTitle,
            btnOkText: '확인',
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
              bloc,
              router: router,
              context: context,
              remoteConfigArgs: environment,
              mapController: _mapController,
              myLocation: myLocation,
              onZoomChanged: () {
                _animatedMapMove(
                  LatLng(
                    bloc.state.myLocation!.latitude!,
                    bloc.state.myLocation!.longitude!,
                  ),
                  bloc.state.zoomThreshold,
                );
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
                    color: ColorName.backgroundLight,
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
                    TopLocationArea(bloc),
                    const SizedBox(height: 16),
                    TopNotice(bloc),
                    const SizedBox(height: 10),
                    TopInformationArea(
                      bloc,
                      cartKey,
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<MainBloc, MainState>(
                      buildWhen: (previous, current) => previous.processingCount != current.processingCount,
                      builder: (context, state) {
                        return state.processingCount == 0
                            ? Container()
                            : Text(
                                "${state.processingCount}개 마커 획득 처리 중..",
                                style: FortuneTextStyle.body3Regular(),
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 16,
              child: TopRefreshTime(bloc),
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
                      ColorName.background.withOpacity(1.0),
                      ColorName.background.withOpacity(0.0),
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

  // 위치변경감지.
  Future<StreamSubscription<LocationData>> listenLocationChange(Location myLocation) async {
    return myLocation.onLocationChanged.listen(
      (newLoc) {
        // _animatedMapMove(
        //   LatLng(
        //     newLoc.latitude!,
        //     newLoc.longitude!,
        //   ),
        //   bloc.state.zoomThreshold,
        // );
        // bloc.add(MainMyLocationChange(newLoc));
      },
    );
  }

  // 카메라 이동 애니메이션.
  void _animatedMapMove(LatLng destLocation, double destZoom) {
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
      content: (context) => MissionsBottomPage(bloc),
    );
  }
}
