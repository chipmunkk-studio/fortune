import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/error/fortune_error_dialog.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/core/util/snackbar.dart';
import 'package:foresh_flutter/core/widgets/bottomsheet/bottom_sheet_ext.dart';
import 'package:foresh_flutter/core/widgets/dialog/defalut_dialog.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/env.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/inventory/inventory_bottom_page.dart';
import 'package:foresh_flutter/presentation/markerobtain/marker_obtain_page.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' show Location, LocationData;
import 'package:permission_handler/permission_handler.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'bloc/main.dart';
import 'component/map/main_map.dart';
import 'component/notice/top_notice.dart';
import 'component/notice/top_ticket_round_time.dart';

class MainPage extends StatelessWidget {
  const MainPage(
    this.landingRoute, {
    Key? key,
  }) : super(key: key);

  final String? landingRoute;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<MainBloc>()..add(MainInit(landingPage: landingRoute)),
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
  late Function(GlobalKey) runAddToCartAnimation;
  LocationData? myLocation;
  bool _detectPermission = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    bloc = BlocProvider.of<MainBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
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
            bloc.add(MainGetLocation());
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
      listener: (context, sideEffect) {
        if (sideEffect is MainLocationChangeListenSideEffect) {
          listenLocationChange(sideEffect.myLocation);
          // 내 위치 잡고 최초에  한번만 다시 그림.
          if (myLocation == null) {
            setState(() {
              myLocation = sideEffect.myLocationData;
            });
          }
        } else if (sideEffect is MainMarkerClickSideEffect) {
          () async {
            await router.navigateTo(
              context,
              Routes.markerObtainAnimationRoute,
              opaque: false,
              routeSettings: RouteSettings(
                arguments: MarkerObtainArgs(
                  sideEffect.obtainMarker,
                ),
              ),
            );
            // 다음 위치 추가.
            bloc.add(MainChangeNewMarkers(sideEffect.newMarkers));
            startAnimation(sideEffect.key);
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
          context.handleError(sideEffect.error);
        } else if (sideEffect is MainRequireInCircleMeters) {
          context.showSnackBar("거리가 ${sideEffect.meters.toInt()}미터 만큼 부족합니다.");
        } else if (sideEffect is MainSchemeLandingPage) {
          router.navigateTo(context, sideEffect.landingRoute);
        }
      },
      child: FortuneScaffold(
        padding: EdgeInsets.zero,
        child: Stack(
          children: [
            // 메인 맵.
            MainMap(
              bloc,
              environment,
              _mapController,
              myLocation,
            ),
            // 카트.
            Positioned.fill(
              child: AddToCartAnimation(
                cartKey: cartKey,
                height: 50,
                width: 50,
                opacity: 0.85,
                dragAnimation: const DragToCartAnimationOptions(
                  rotation: true,
                ),
                jumpAnimation: const JumpAnimationOptions(),
                createAddToCartAnimation: (runAddToCartAnimation) {
                  this.runAddToCartAnimation = runAddToCartAnimation;
                },
                child: Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _onMyBagClick,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: AddToCartIcon(
                        key: cartKey,
                        icon: Container(
                          decoration: BoxDecoration(
                            color: ColorName.backgroundLight,
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Assets.icons.icInventory.svg(),
                          ),
                        ),
                        badgeOptions: const BadgeOptions(active: false),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 13,
              right: 20,
              left: 20,
              child: Column(
                children: [
                  TopNotice(bloc),
                  const SizedBox(height: 10),
                  TopTicketRoundTime(bloc),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 위치변경감지.
  void listenLocationChange(Location myLocation) async {
    myLocation.onLocationChanged.listen(
      (newLoc) {
        // _animatedMapMove(
        //   LatLng(
        //     newLoc.latitude!,
        //     newLoc.longitude!,
        //   ),
        //   bloc.state.zoomThreshold,
        // );
        bloc.add(MainMyLocationChange(newLoc));
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
  void startAnimation(GlobalKey? key) async {
    if (key != null) {
      await runAddToCartAnimation(key);
    }
    await cartKey.currentState!.runCartAnimation();
  }

  _onMyBagClick() {
    context.showFortuneBottomSheet(
      content: (context) => const InventoryBottomPage(),
    );
  }
}
