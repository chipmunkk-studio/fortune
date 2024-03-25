enum MarkerItemType {
  COIN, // 코인.
  NORMAL, // 노말.
  NONE
}

enum MarkerImageType {
  PNG, // 이미지.
  LOTTIE, // 로띠.
  NONE
}

MarkerItemType getMarkerItemType(String? type) {
  if (MarkerItemType.COIN.name == type) {
    return MarkerItemType.COIN;
  } else if (MarkerItemType.NORMAL.name == type) {
    return MarkerItemType.NORMAL;
  } else {
    return MarkerItemType.NONE;
  }
}

MarkerImageType getMarkerImageType(String? type) {
  if (MarkerImageType.PNG.name == type) {
    return MarkerImageType.PNG;
  } else if (MarkerImageType.LOTTIE.name == type) {
    return MarkerImageType.LOTTIE;
  } else {
    return MarkerImageType.NONE;
  }
}
