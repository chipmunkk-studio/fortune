import 'dart:math' as math;

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/core/widgets/animation/linear_bounce_animation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'component/map/main_location_data.dart';
import 'component/map/main_marker_view.dart';

class MainLandingArgs {
  // 히스토리 검색.
  final String text;

  MainLandingArgs({
    this.text = '',
  });
}

double isMarkerInsideCircle(
  LatLng currentPosition,
  LatLng targetPosition,
  double clickableRadiusLength,
) {
  var distanceInMeters = Geolocator.distanceBetween(
    targetPosition.latitude,
    targetPosition.longitude,
    currentPosition.latitude,
    currentPosition.longitude,
  );
  return distanceInMeters - clickableRadiusLength;
}

extension FortuneMapDataConverter on List<MainLocationData> {
  List<Marker> toMarkerList(
    Function2<MainLocationData, GlobalKey, void> onMarkerClick,
  ) {
    return map((e) {
      return Marker(
        width: 64,
        height: 64,
        point: LatLng(
          e.location.latitude,
          e.location.longitude,
        ),
        builder: (BuildContext context) {
          return LinearBounceAnimation(
            child: MainMarkerView(
              marker: e,
              onMarkerClick: onMarkerClick,
            ),
          );
        },
      );
    }).toList();
  }
}

SvgPicture getMarkerIcon(int grade) {
  const double size = 60;
  switch (grade) {
    case 1:
      return Assets.icons.icFortuneCookie.svg(width: size, height: size);
    default:
      return Assets.icons.icFortuneCookie.svg(width: size, height: size);
  }
}

SvgPicture getMarkerDisappearedIcon(int grade) {
  const double size = 60;
  switch (grade) {
    case 1:
      return Assets.icons.icFortuneCookie.svg(width: size, height: size);
    default:
      return Assets.icons.icFortuneCookie.svg(width: size, height: size);
  }
}
//  LatLng(latitude:37.553418, longitude:127.068747), distance: -222.17263545827225

// degrees to radians 변환을 위한 함수
double degreesToRadians(double degrees) {
  return degrees * math.pi / 180;
}

void generateRandomMarkers({
  double centerLat = 37.553418,
  double centerLng = 127.068747,
  double radiusInMeters = 100,
  int numberOfMarkers = 10,
}) {
  final List<Marker> markers = [];
  final double radiusInDegrees = radiusInMeters / 111300;
  final rand = math.Random();

  for (int i = 0; i < numberOfMarkers; i++) {
    final double u = rand.nextDouble();
    final double v = rand.nextDouble();
    final double w = radiusInDegrees * math.sqrt(u);
    final double t = 2 * math.pi * v;
    final double x = w * math.cos(t);
    final double y = w * math.sin(t);

    // Adjust the x-coordinate for the shrinking of the east-west distances
    final double new_x = x / math.cos(degreesToRadians(centerLat));

    final double foundLatitude = new_x + centerLat;
    final double foundLongitude = y + centerLng;
    FortuneLogger.info("latitude: $foundLatitude, longitude: $foundLongitude");
    // final Marker marker = Marker(
    //   markerId: MarkerId(i.toString()),
    //   position: LatLng(foundLatitude, foundLongitude),
    // );
    //
    // markers.add(marker);
  }

  // 여기서 markers를 GoogleMap에 추가하세요.
}
