import 'package:avatar_glow/avatar_glow.dart';
import 'package:dartz/dartz.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/core/widgets/animation/scale_animation.dart';
import 'package:fortune/env.dart';
import 'package:fortune/presentation/main/bloc/main.dart';
import 'package:fortune/presentation/main/component/map/main_location_data.dart';
import 'package:fortune/presentation/main/main_ext.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'center_profile.dart';
import 'obtain_loading_view.dart';

class MainMap extends StatelessWidget {
  final BuildContext context;
  final MainBloc _bloc;
  final FluroRouter router;
  final MapController mapController;
  final FortuneRemoteConfig remoteConfigArgs;
  final Position? myLocation;
  final Function0 onZoomChanged;

  const MainMap(
    this._bloc, {
    Key? key,
    required this.context,
    required this.router,
    required this.remoteConfigArgs,
    required this.mapController,
    required this.myLocation,
    required this.onZoomChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return myLocation == null
        ? const Center(child: CircularProgressIndicator(backgroundColor: ColorName.primary))
        : Stack(
            children: [
              // 메인맵.
              FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  center: LatLng(
                    myLocation!.latitude!,
                    myLocation!.longitude!,
                  ),
                  zoom: _bloc.state.zoomThreshold,
                  interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.rotate,
                  onPositionChanged: (mapPosition, boolHasGesture) {
                    if (boolHasGesture) {
                      onZoomChanged();
                    }
                  },
                  onTap: (tapPosition, point) {
                    FortuneLogger.debug(
                      tag: "gradeTest",
                      "point: $point, distance: ${isMarkerInsideCircle(
                        LatLng(_bloc.state.myLocation!.latitude!, _bloc.state.myLocation!.longitude!),
                        point,
                        _bloc.state.clickableRadiusLength,
                      )}",
                    );
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: remoteConfigArgs.mapUrlTemplate,
                    additionalOptions: {
                      'accessToken': remoteConfigArgs.mapAccessToken,
                      'mapStyleId': remoteConfigArgs.mapStyleId,
                    },
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
                              color: ColorName.primary.withOpacity(0.1),
                              borderStrokeWidth: 0,
                              useRadiusInMeter: true,
                              radius: state.clickableRadiusLength * 2,
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
                    glowColor: ColorName.primary.withOpacity(0.5),
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
                            backgroundColor: const Color(0xff7367FF).withOpacity(1.0),
                          ),
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

  // 마커를 클릭했을 경우.
  _onMarkerClick(
    MainLocationData data,
    GlobalKey globalKey,
  ) async {
    LatLng markerPosition = LatLng(data.location.latitude, data.location.longitude);
    LatLng currentPosition = LatLng(
      _bloc.state.myLocation!.latitude!,
      _bloc.state.myLocation!.longitude!,
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
