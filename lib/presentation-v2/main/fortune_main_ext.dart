import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fortune/core/fortune_ext.dart';
import 'package:fortune/core/widgets/animation/linear_bounce_animation.dart';
import 'package:fortune/core/widgets/fortune_cached_network_Image.dart';
import 'package:fortune/core/widgets/fortune_lottie_widget.dart';
import 'package:fortune/core/widgets/painter/fortune_map_grid_painter.dart';
import 'package:fortune/data/remote/response/fortune_response_ext.dart';
import 'package:fortune/domain/entity/marker_entity.dart';
import 'package:fortune/presentation-v2/main/component/marker_view.dart';
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

buildIngredientByPlayType({
  required String url,
  ImageType type = ImageType.WEBP,
  double? width,
  double? height,
  ImageShape? imageShape,
  BoxFit? fit,
}) {
  switch (type) {
    case ImageType.LOTTIE:
      return FortuneLottieWidget(
        lottieUrl: url,
        width: width,
        height: height,
      );
    default:
      return FortuneCachedNetworkImage(
        width: width,
        height: height,
        imageUrl: url,
        imageShape: imageShape ?? ImageShape.circle,
        placeholder: Container(),
        errorWidget: const SizedBox.shrink(),
        fit: fit ?? BoxFit.contain,
      );
  }
}

extension FortuneMapDataConverter on List<MarkerEntity> {
  List<Marker> toMarkerList(
    Function1<MarkerEntity, void> onMarkerClick,
  ) {
    return map(
      (e) {
        final isCoinMarker = e.itemType == MarkerItemType.COIN;
        return Marker(
          width: isCoinMarker ? 52 : 80,
          height: isCoinMarker ? 52 : 80,
          point: LatLng(
            e.latitude,
            e.longitude,
          ),
          child: LinearBounceAnimation(
            child: MarkerView(
              key: ValueKey(e.id),
              marker: e,
              onMarkerClick: onMarkerClick,
            ),
          ),
        );
      },
    ).toList();
  }
}
