import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/core/widgets/animation/linear_bounce_animation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'component/map/main_location_data.dart';
import 'component/map/main_marker_view.dart';

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
  FortuneLogger.debug("distanceInMeters: $distanceInMeters, clickableRadiusLength:$clickableRadiusLength");
  return distanceInMeters - clickableRadiusLength;
}

extension FortuneMapDataConverter on List<MainLocationData> {
  List<Marker> toMarkerList(
    Function4<GlobalKey, int, double, double, void> onMarkerClick,
  ) {
    return map((e) {
      int locationId = e.id;
      double latitude = e.location.latitude;
      double longitude = e.location.longitude;
      bool disappeared = e.disappeared;
      return Marker(
        width: 64,
        height: 64,
        point: LatLng(latitude, longitude),
        builder: (BuildContext context) {
          return LinearBounceAnimation(
            child: MainMarkerView(
              id: locationId,
              latitude: latitude,
              longitude: longitude,
              widgetKey: e.widgetKey,
              grade: e.grade,
              onMarkerClick: onMarkerClick,
              disappeared: disappeared,
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

