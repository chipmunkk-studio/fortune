import 'dart:io';

import 'package:flutter/foundation.dart';

class AdHelper {
  static const Map<String, Map<String, String>> _ads = {
    'android': {
      'banner': '<YOUR_ANDROID_BANNER_AD_UNIT_ID>',
      'interstitial': '<YOUR_ANDROID_INTERSTITIAL_AD_UNIT_ID>',
      'rewarded': kReleaseMode ? 'ca-app-pub-8638803250596668/2298231057' : 'ca-app-pub-3940256099942544/5224354917',
    },
    'ios': {
      'banner': '<YOUR_IOS_BANNER_AD_UNIT_ID>',
      'interstitial': '<YOUR_IOS_INTERSTITIAL_AD_UNIT_ID>',
      'rewarded': kReleaseMode ? 'ca-app-pub-8638803250596668/3666280902' : 'ca-app-pub-3940256099942544/1712485313',
    }
  };

  static String _getPlatformKey() {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    throw UnsupportedError('Unsupported platform');
  }

  // 배너.
  static String get bannerAdUnitId => _ads[_getPlatformKey()]?['banner'] ?? '';

  // 전면.
  static String get interstitialAdUnitId => _ads[_getPlatformKey()]?['interstitial'] ?? '';

  // 보상형.
  static String get rewardedAdUnitId => _ads[_getPlatformKey()]?['rewarded'] ?? '';
}
