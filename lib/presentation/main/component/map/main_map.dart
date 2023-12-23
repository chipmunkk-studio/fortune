import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fortune/core/fortune_ext.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/core/widgets/animation/scale_animation.dart';
import 'package:fortune/core/widgets/fortune_loading_view.dart';
import 'package:fortune/core/widgets/painter/direction_painter.dart';
import 'package:fortune/core/widgets/painter/fortune_map_grid_painter.dart';
import 'package:fortune/core/widgets/painter/fortune_radar_background.dart';
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

  final AnimationController centerRotateController;
  static const accessToken = 'accessToken';
  static const mapStyleId = 'mapStyleId';

  const MainMap(
    this._bloc, {
    super.key,
    required this.mainContext,
    required this.remoteConfigArgs,
    required this.mapController,
    required this.myLocation,
    required this.onZoomChanged,
    required this.centerRotateController,
  });

  @override
  Widget build(BuildContext context) {
    return myLocation == null
        ? const Center(child: FortuneLoadingView())
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
                      tag: "LocationTest",
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
                  _getLayerByMapType(remoteConfigArgs),
                  // 마커 목록.
                  BlocBuilder<MainBloc, MainState>(
                    buildWhen: (previous, current) => previous.markers != current.markers,
                    builder: (context, state) {
                      return MarkerLayer(
                        markers: state.markers.toMarkerList(_onMarkerClick),
                      );
                    },
                  ),
                ],
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: FortuneRadarBackground(),
                  ),
                ),
              ),
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
                            painter: DirectionPainter(_isOpenStreetMap()),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Center(
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: centerRotateController,
                    builder: (BuildContext context, Widget? child) {
                      return Transform.rotate(
                        angle: centerRotateController.value * 2 * pi,
                        child: Assets.icons.icRadarRotate.svg(),
                      );
                    },
                  ),
                ),
              ),
              Center(
                child: IgnorePointer(
                  child: ScaleAnimation(
                    child: BlocBuilder<MainBloc, MainState>(
                      buildWhen: (previous, current) => previous.user?.profileImage != current.user?.profileImage,
                      builder: (context, state) {
                        return CenterProfile(
                          imageUrl: state.user?.profileImage ?? "",
                          backgroundColor: _isOpenStreetMap()
                              ? ColorName.primary.withOpacity(0.5)
                              : ColorName.secondary.withOpacity(1.0),
                        );
                      },
                    ),
                  ),
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

  _isOpenStreetMap() => remoteConfigArgs.mapType == MapType.openStreet;

  _getLayerByMapType(FortuneRemoteConfig remoteConfigArgs) {
    switch (remoteConfigArgs.mapType) {
      case MapType.openStreet:
        return TileLayer(
          tileSize: 512,
          zoomOffset: -1,
          urlTemplate: openStreetMap,
        );
      case MapType.mapBox:
        return kReleaseMode
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
                painter: FortuneMapGridPainter(gridSpacing: 26),
                child: Container(),
              );
      default:
        return CustomPaint(
          painter: FortuneMapGridPainter(gridSpacing: 26),
          child: Container(),
        );
    }
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
