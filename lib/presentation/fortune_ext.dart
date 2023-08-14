// 투명 이미지.
import 'dart:math';

import 'package:dartz/dartz.dart';

const transparentImageUrl = "https://via.placeholder.com/1x1.png?text=+&bg=ffffff00";

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
