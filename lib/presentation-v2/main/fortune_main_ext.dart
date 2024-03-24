import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fortune/core/fortune_ext.dart';
import 'package:fortune/core/widgets/painter/fortune_map_grid_painter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

getLayerByMapType() {
  try {
    return TileLayer(
      urlTemplate: openStreetMap,
      tileBuilder: _darkModeTileBuilder,
    );
  } catch (e) {
    return CustomPaint(
      painter: FortuneMapGridPainter(gridSpacing: 26),
      child: Container(),
    );
  }
}

Widget _darkModeTileBuilder(
  BuildContext context,
  Widget tileWidget,
  TileImage tile,
) {
  return ColorFiltered(
    colorFilter: const ColorFilter.matrix(
      <double>[
        -0.2126, -0.7152, -0.0722, 0, 240, // Red channel
        -0.2126, -0.7152, -0.0722, 0, 240, // Green channel
        -0.2126, -0.7152, -0.0722, 0, 240, // Blue channel
        0, 0, 0, 1, 0, // Alpha channel
      ],
    ),
    child: tileWidget,
  );
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


