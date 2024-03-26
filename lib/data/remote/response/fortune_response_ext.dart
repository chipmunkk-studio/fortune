enum MarkerItemType {
  COIN, // 코인.
  NORMAL, // 노말.
  SCRATCH, // 스크래치.
  NONE
}

enum ImageType {
  PNG, // 이미지.
  LOTTIE, // 로띠.
  WEBP, // 웹피.
  NONE
}

MarkerItemType getMarkerItemType(String? type) {
  if (MarkerItemType.COIN.name == type) {
    return MarkerItemType.COIN;
  } else if (MarkerItemType.NORMAL.name == type) {
    return MarkerItemType.NORMAL;
  } else if (MarkerItemType.SCRATCH.name == type) {
    return MarkerItemType.SCRATCH;
  } else {
    return MarkerItemType.NONE;
  }
}

ImageType getImageType(String? type) {
  if (ImageType.PNG.name == type) {
    return ImageType.PNG;
  } else if (ImageType.LOTTIE.name == type) {
    return ImageType.LOTTIE;
  } else if (ImageType.WEBP.name == type) {
    return ImageType.WEBP;
  } else {
    return ImageType.NONE;
  }
}
