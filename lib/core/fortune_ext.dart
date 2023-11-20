// 투명 이미지.
import 'dart:io';
import 'dart:math' as math;

import 'package:dartz/dartz.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

const transparentImageUrl = "https://via.placeholder.com/1x1.png?text=+&bg=ffffff00";
const openStreetMap = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';

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

Future<bool> getPhysicalMobileDevice() async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if (Platform.isIOS) {
    final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.isPhysicalDevice;
  } else if (Platform.isAndroid) {
    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.isPhysicalDevice;
  }

  return false;
}

void reportRandomTimes({
  required int min,
  required int max,
  required Function0 func,
}) {
  var rng = math.Random();
  int n = rng.nextInt(max - min + 1) + min; // min부터 max까지의 랜덤한 숫자를 생성합니다.

  for (int i = 0; i < n; i++) {
    func();
  }
}

void launchStore(Function onLaunchAfter) async {
  String url;
  if (Platform.isAndroid) {
    url = 'https://play.google.com/store/apps/details?id=com.foresh.fortune';
  } else if (Platform.isIOS) {
    url = 'https://apps.apple.com/app/id6465523666';
  } else {
    url = '';
  }

  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
    onLaunchAfter();
  } else {
    // 에러 무시.
  }
}
