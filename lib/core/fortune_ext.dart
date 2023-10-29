// 투명 이미지.
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';

const transparentImageUrl = "https://via.placeholder.com/1x1.png?text=+&bg=ffffff00";
const webMainUrl = "https://chipmunk-studio.com";
Position simulatorLocation = Position(
  latitude: 37.785834,
  longitude: -122.406417,
  timestamp: DateTime.now(),
  accuracy: 5.0,
  altitude: 0.0,
  altitudeAccuracy: 0.0,
  heading: 90.0,
  headingAccuracy: 0.0,
  speed: 0.0,
  speedAccuracy: 0.0,
);

// 샘플 이미지.
String getSampleNetworkImageUrl({
  required int width,
  required int height,
}) {
  return "https://source.unsplash.com/user/max_duz/${width}x$height";
}

void reportRandomTimes({
  required int min,
  required int max,
  required Function0 func,
}) {
  var rng = Random();
  int n = rng.nextInt(max - min + 1) + min; // min부터 max까지의 랜덤한 숫자를 생성합니다.

  for (int i = 0; i < n; i++) {
    func();
  }
}
