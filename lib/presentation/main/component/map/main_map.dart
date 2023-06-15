  import 'package:avatar_glow/avatar_glow.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/core/widgets/animation/scale_animation.dart';
import 'package:foresh_flutter/env.dart';
import 'package:foresh_flutter/presentation/main/bloc/main.dart';
import 'package:foresh_flutter/presentation/main/component/map/main_location_data.dart';
import 'package:foresh_flutter/presentation/main/main_ext.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import 'center_profile.dart';

class MainMap extends StatelessWidget {
  final MainBloc _bloc;
  final MapController _mapController;
  final FortuneRemoteConfig _remoteConfigArgs;
  final LocationData? _myLocation;
  final Function0 onZoomChanged;

  const MainMap(
    this._bloc,
    this._remoteConfigArgs,
    this._mapController,
    this._myLocation, {
    Key? key,
    required this.onZoomChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _myLocation == null
        ? const Center(child: CircularProgressIndicator(backgroundColor: ColorName.primary))
        : Stack(
            children: [
              // 메인맵.
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: LatLng(
                    _myLocation!.latitude!,
                    _myLocation!.longitude!,
                    // 37.559357,
                    // 126.971477,
                  ),
                  zoom: _bloc.state.zoomThreshold,
                  interactiveFlags: InteractiveFlag.pinchZoom,
                  onPositionChanged: (mapPosition, boolHasGesture) {
                    // if (boolHasGesture) {
                    //   onZoomChanged();
                    // }
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
                    urlTemplate: _remoteConfigArgs.mapUrlTemplate,
                    additionalOptions: {
                      'accessToken': _remoteConfigArgs.mapAccessToken,
                      'mapStyleId': _remoteConfigArgs.mapStyleId,
                    },
                  ),
                  // 마커 목록.
                  BlocBuilder<MainBloc, MainState>(
                    buildWhen: (previous, current) => previous.markers != current.markers,
                    builder: (context, state) {
                      return MarkerLayer(
                        markers: state.markers.toMarkerList(
                          _onMarkerClick,
                        ),
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
                                state.myLocation!.latitude!,
                                state.myLocation!.longitude!,
                              ),
                              color: ColorName.deActive.withOpacity(0.1),
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
                    glowColor: ColorName.negative,
                    duration: const Duration(milliseconds: 2000),
                    repeat: true,
                    showTwoGlows: true,
                    repeatPauseDuration: const Duration(milliseconds: 5),
                    endRadius: 120,
                    child: BlocBuilder<MainBloc, MainState>(
                      buildWhen: (previous, current) => previous.profileImage != current.profileImage,
                      builder: (context, state) {
                        return ScaleAnimation(
                          child: CenterProfile(
                            imageUrl: state.profileImage ?? "",
                            backgroundColor: const Color(0xff7367FF).withOpacity(1.0),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
  }

  _onMarkerClick(
    MainLocationData data,
    GlobalKey globalKey,
  ) async {
    LatLng markerPosition = LatLng(
      data.location.latitude,
      data.location.longitude,
    );
    LocationData myLocation = _bloc.state.myLocation!;
    LatLng currentPosition = LatLng(
      myLocation.latitude!,
      myLocation.longitude!,
    );
    final double distance = isMarkerInsideCircle(
      currentPosition,
      markerPosition,
      _bloc.state.clickableRadiusLength,
    );
    // todo 광고 보여주고 수행함.
    // await Future.delayed(const Duration(seconds: 200));
    _bloc.add(
      MainMarkerClick(
        data: data,
        distance: distance,
        globalKey: globalKey,
      ),
    );
  }
}
