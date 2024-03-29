import 'dart:math' as math;

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/core/widgets/animation/linear_bounce_animation.dart';
import 'package:fortune/core/widgets/fortune_cached_network_Image.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../core/widgets/fortune_lottie_widget.dart';
import 'component/map/main_location_data.dart';
import 'component/map/main_marker_view.dart';

const LocationAccuracy mapLocationAccuracy = LocationAccuracy.high;
const  ticketThreshold = 2000;

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
    return map(
      (e) {
        final isCoinMarker = e.ingredient.type == IngredientType.coin;
        return Marker(
          width: isCoinMarker ? 52 : 80,
          height: isCoinMarker ? 52 : 80,
          point: LatLng(
            e.location.latitude,
            e.location.longitude,
          ),
          child: LinearBounceAnimation(
            child: MainMarkerView(
              marker: e,
              onMarkerClick: onMarkerClick,
            ),
          ),
        );
      },
    ).toList();
  }
}

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
  }
}

buildIngredientByPlayType(
  IngredientEntity ingredientEntity, {
  double? width,
  double? height,
  ImageShape? imageShape,
  BoxFit? fit,
}) {
  switch (ingredientEntity.image.type) {
    case IngredientImageType.lottie:
      return FortuneLottieWidget(
        lottieUrl: ingredientEntity.image.imageUrl,
        width: width,
        height: height,
      );
    default:
      return FortuneCachedNetworkImage(
        width: width,
        height: height,
        imageUrl: ingredientEntity.image.imageUrl,
        imageShape: imageShape ?? ImageShape.circle,
        placeholder: Container(),
        errorWidget: const SizedBox.shrink(),
        fit: fit ?? BoxFit.contain,
      );
  }
}
