import 'dart:io';

import 'package:flutter/foundation.dart';

class AdmobHelper {
  static const Map<String, Map<String, String>> _ads = {
    'android': {
      'banner': kReleaseMode ? 'ca-app-pub-8638803250596668/7886133459' : 'ca-app-pub-3940256099942544/6300978111',
      'interstitial': kReleaseMode ? 'ca-app-pub-8638803250596668/8465513453' : 'ca-app-pub-3940256099942544/5354046379',
      'rewarded': kReleaseMode ? 'ca-app-pub-8638803250596668/2298231057' : 'ca-app-pub-3940256099942544/5224354917',
    },
    'ios': {
      'banner': kReleaseMode ? 'ca-app-pub-8638803250596668/8868042637' : 'ca-app-pub-3940256099942544/2934735716',
      'interstitial': kReleaseMode ? 'ca-app-pub-8638803250596668/7886133459' : 'ca-app-pub-3940256099942544/6978759866',
      'rewarded': kReleaseMode ? 'ca-app-pub-8638803250596668/4990925070' : 'ca-app-pub-3940256099942544/1712485313',
    }
  };

  // 배너.
  static String get bannerAdUnitId => _ads[_getPlatformKey()]?['banner'] ?? '';

  // 전면.
  static String get interstitialAdUnitId => _ads[_getPlatformKey()]?['interstitial'] ?? '';

  // 보상형.
  static String get rewardedAdUnitId => _ads[_getPlatformKey()]?['rewarded'] ?? '';
}

class VungleAdHelper {
  static const Map<String, Map<String, String>> _ads = {
    'android': {
      'banner': '',
      'interstitial': '',
      'rewarded': 'REWARD-4486627',
    },
    'ios': {
      'banner': '',
      'interstitial': '',
      'rewarded': 'REWARD-8850293',
    }
  };

  static const Map<String, String> _appKey = {
    'android': '655dd88e87876843d0b54e5a',
    'ios': '655dd7ea41519bc7542282cc',
  };

  static String get appKey => _appKey[_getPlatformKey()] ?? '';

  // 배너.
  static String get bannerAdUnitId => _ads[_getPlatformKey()]?['banner'] ?? '';

  // 전면.
  static String get interstitialAdUnitId => _ads[_getPlatformKey()]?['interstitial'] ?? '';

  // 보상형.
  static String get rewardedAdUnitId => _ads[_getPlatformKey()]?['rewarded'] ?? '';
}

String _getPlatformKey() {
  if (Platform.isAndroid) return 'android';
  if (Platform.isIOS) return 'ios';
  throw UnsupportedError('Unsupported platform');
}
