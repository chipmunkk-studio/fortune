import 'package:avatar_glow/avatar_glow.dart';
import 'package:dartz/dartz.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/core/widgets/animation/scale_animation.dart';
import 'package:fortune/core/widgets/painter/fortune_map_grid_painter.dart';
import 'package:fortune/env.dart';
import 'package:fortune/presentation/main/bloc/main.dart';
import 'package:fortune/presentation/main/component/map/main_location_data.dart';
import 'package:fortune/presentation/main/main_ext.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'center_profile.dart';
import 'obtain_loading_view.dart';

class MainMap extends StatelessWidget {
  final BuildContext mainContext;
  final MainBloc _bloc;
  final MapController mapController;
  final FortuneRemoteConfig remoteConfigArgs;
  final Position? myLocation;
  final Function0 onZoomChanged;

  static const accessToken = 'accessToken';
  static const mapStyleId = 'mapStyleId';

  const MainMap(
    this._bloc, {
    Key? key,
    required this.mainContext,
    required this.remoteConfigArgs,
    required this.mapController,
    required this.myLocation,
    required this.onZoomChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final enableMapBox = remoteConfigArgs.enableMapBox && kReleaseMode;
    return myLocation == null
        ? const Center(child: CircularProgressIndicator(backgroundColor: ColorName.primary))
        : Stack(
            children: [
              // 메인맵.
              FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  initialCenter: LatLng(
                    myLocation!.latitude,
                    myLocation!.longitude,
                  ),
                  initialZoom: _bloc.state.zoomThreshold,
                  minZoom: 16.0,
                  maxZoom: 18.0,
                  interactiveFlags: InteractiveFlag.pinchZoom,
                  onPositionChanged: (mapPosition, boolHasGesture) {
                    if (boolHasGesture) {
                      onZoomChanged();
                    }
                  },
                  onTap: (tapPosition, point) {
                    FortuneLogger.debug(
                      tag: "gradeTest",
                      "point: $point, distance: ${isMarkerInsideCircle(
                        LatLng(
                          _bloc.state.myLocation!.latitude,
                          _bloc.state.myLocation!.longitude,
                        ),
                        point,
                        _bloc.state.clickableRadiusLength,
                      )}",
                    );
                  },
                ),
                children: [
                  enableMapBox
                      ? TileLayer(
                          tileSize: 512,
                          zoomOffset: -1,
                          urlTemplate: remoteConfigArgs.mapUrlTemplate,
                          additionalOptions: {
                            accessToken: remoteConfigArgs.mapAccessToken,
                            mapStyleId: remoteConfigArgs.mapStyleId,
                          },
                        )
                      : CustomPaint(
                          painter: FortuneMapGridPainter(gridSpacing: 23),
                          child: Container(),
                        ),
                  // 마커 목록.
                  BlocBuilder<MainBloc, MainState>(
                    buildWhen: (previous, current) => previous.markers != current.markers,
                    builder: (context, state) {
                      return MarkerLayer(
                        markers: state.markers.toMarkerList(_onMarkerClick),
                      );
                    },
                  ),
                  IgnorePointer(
                    child: BlocBuilder<MainBloc, MainState>(
                      buildWhen: (previous, current) =>
                          previous.myLocation != current.myLocation ||
                          previous.clickableRadiusLength != current.clickableRadiusLength,
                      builder: (context, state) {
                        return CircleLayer(
                          circles: <CircleMarker>[
                            CircleMarker(
                              point: LatLng(
                                state.myLocation!.latitude,
                                state.myLocation!.longitude,
                              ),
                              color: enableMapBox
                                  ? ColorName.secondary.withOpacity(0.1)
                                  : ColorName.primary.withOpacity(0.1),
                              borderStrokeWidth: 0,
                              useRadiusInMeter: true,
                              radius: state.clickableRadiusLength,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: AvatarGlow(
                    glowColor: enableMapBox ? ColorName.secondary.withOpacity(0.5) : ColorName.primary.withOpacity(0.5),
                    duration: const Duration(milliseconds: 2000),
                    repeat: true,
                    showTwoGlows: true,
                    repeatPauseDuration: const Duration(seconds: 1),
                    endRadius: 120,
                    child: BlocBuilder<MainBloc, MainState>(
                      buildWhen: (previous, current) => previous.user?.profileImage != current.user?.profileImage,
                      builder: (context, state) {
                        return ScaleAnimation(
                          child: CenterProfile(
                            imageUrl: state.user?.profileImage ?? "",
                            backgroundColor: enableMapBox
                                ? ColorName.secondary.withOpacity(1.0)
                                : ColorName.primary.withOpacity(1.0),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              // 좌측 하단 로테이션.
              Positioned(
                bottom: 16,
                left: 16,
                child: BlocBuilder<MainBloc, MainState>(
                  buildWhen: (previous, current) => previous.isRotatable != current.isRotatable,
                  builder: (context, state) {
                    return Bounceable(
                      onTap: () => _bloc.add(MainTabCompass()),
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorName.grey700,
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: state.isRotatable
                              ? Assets.icons.icLocationRotate.svg()
                              : Assets.icons.icLocationHold.svg(),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // 로딩 뷰.
              Positioned.fill(
                child: BlocBuilder<MainBloc, MainState>(
                  buildWhen: (previous, current) => previous.isObtainProcessing != current.isObtainProcessing,
                  builder: (context, state) {
                    final processingMarker = state.processingMarker;
                    final isLoading = state.isObtainProcessing;
                    return ObtainLoadingView(
                      isLoading: isLoading,
                      processingMarker: processingMarker,
                    );
                  },
                ),
              ),
            ],
          );
  }

  // 마커를 클릭했을 경우.
  _onMarkerClick(
    MainLocationData data,
    GlobalKey globalKey,
  ) async {
    LatLng markerPosition = LatLng(data.location.latitude, data.location.longitude);
    LatLng currentPosition = LatLng(
      _bloc.state.myLocation!.latitude,
      _bloc.state.myLocation!.longitude,
    );

    final double distance = isMarkerInsideCircle(
      currentPosition,
      markerPosition,
      _bloc.state.clickableRadiusLength,
    );

    _bloc.add(
      MainMarkerClick(
        data: data,
        globalKey: globalKey,
        distance: distance,
      ),
    );
  }
}
