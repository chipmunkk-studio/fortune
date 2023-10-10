import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/adhelper.dart';
import 'package:fortune/core/util/strings.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../core/util/logger.dart';

enum BuildType {
  dev,
  product,
}

enum EnvKey {
  devAnonKey,
  devUrl,
  productAnonKey,
  productUrl,
  mapAccessToken,
  mapStyleId,
  mapUrlTemplate,
  mixpanelToken,
  randomDistance,
  refreshTime,
  ticketCount,
  markerCount,
  androidGoogleClientId,
  iosGoogleClientId,
  testSignInEmail,
  testSignInPassword,
}

class FortuneRemoteConfig {
  final String anonKey;
  final String baseUrl;
  final String mapAccessToken;
  final String mapStyleId;
  final String mapUrlTemplate;
  final String mixpanelToken;
  final String testSignInEmail;
  final String testSignInPassword;
  final double randomDistance;
  final int refreshTime;
  final int markerCount;
  final int ticketCount;

  FortuneRemoteConfig({
    required this.baseUrl,
    required this.mapAccessToken,
    required this.mapStyleId,
    required this.mapUrlTemplate,
    required this.mixpanelToken,
    required this.anonKey,
    required this.randomDistance,
    required this.markerCount,
    required this.ticketCount,
    required this.testSignInEmail,
    required this.testSignInPassword,
    required this.refreshTime,
  });

  @override
  String toString() {
    return "\nbaseUrl: $baseUrl,\n"
        "mapAccessToken: ${mapAccessToken.shortenForPrint()},\n"
        "mapStyleId: ${mapStyleId.shortenForPrint()},\n"
        "mapUrlTemplate: ${mapUrlTemplate.shortenForPrint()},\n"
        "testSignInEmail: $testSignInEmail,\n"
        "testSignInPassword: $testSignInPassword,\n"
        "mixpanelToken: $mixpanelToken\n"
        "refreshTime: $refreshTime\n"
        "ticketCount: $ticketCount\n"
        "markerCount: $markerCount\n"
        "randomDistance: $randomDistance\n"
        "anonKey: ${anonKey.shortenForPrint()}\n";
  }
}

class Environment {
  static const tag = "[Environment]";
  static const translation = "assets/translations";

  late BuildType buildType;
  final FortuneRemoteConfig remoteConfig;

  Environment.create({
    required this.remoteConfig,
  });

  /// 앱에서 지원하는 언어 리스트 변수
  static final supportedLocales = [
    const Locale('en', 'US'),
    const Locale('ko', 'KR'),
  ];

  bool get isDebuggable => buildType == BuildType.dev;

  init() async {
    /// 빌드 타입.
    buildType = () {
      if (kReleaseMode) {
        return BuildType.product;
      } else {
        return BuildType.dev;
      }
    }();

    /// 세로모드 고정.
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    /// 파이어베이스 crashlytics
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    // [WEB] 웹은 크래실리틱스 수집 안함.
    if (!kIsWeb) {
      FirebaseCrashlytics.instance
        ..setCustomKey("appName", packageInfo.appName)
        ..setCustomKey("packageName", packageInfo.packageName)
        ..setCustomKey("version", packageInfo.version)
        ..setCustomKey("buildNumber", packageInfo.buildNumber)
        ..setCustomKey("buildType", buildType.toString());

      if (kDebugMode) {
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
      } else {
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      }
    }

    FortuneLogger.info(
      "buildType: $buildType,\n"
      "--------------configArgs--------------"
      "${remoteConfig.toString()}"
      "rewardAdUnitId: ${AdHelper.rewardedAdUnitId}\n"
      "--------------------------------------",
    );
  }
}

// baseUrl 가져옴.
getRemoteConfigArgs() async {
  final remoteConfig = FirebaseRemoteConfig.instance;

  /// 0초을 사용하여 서버에서 강제로 가져옵니다.
  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: Duration.zero,
    ),
  );

  try {
    await remoteConfig.fetchAndActivate();
    final mixpanelToken = remoteConfig.getString(describeEnum(EnvKey.mixpanelToken));
    final mapAccessToken = remoteConfig.getString(describeEnum(EnvKey.mapAccessToken));
    final mayStyleId = remoteConfig.getString(describeEnum(EnvKey.mapStyleId));
    final mapUrlTemplate = remoteConfig.getString(describeEnum(EnvKey.mapUrlTemplate));
    final randomDistance = remoteConfig.getDouble(describeEnum(EnvKey.randomDistance));
    final refreshTime = remoteConfig.getInt(describeEnum(EnvKey.refreshTime));
    final ticketCount = remoteConfig.getInt(describeEnum(EnvKey.ticketCount));
    final markerCount = remoteConfig.getInt(describeEnum(EnvKey.markerCount));
    final testSignInPassword = remoteConfig.getString(describeEnum(EnvKey.testSignInPassword));
    final testSignInEmail = remoteConfig.getString(describeEnum(EnvKey.testSignInEmail));

    final baseUrl = remoteConfig.getString(() {
      switch (kReleaseMode) {
        case true:
          return describeEnum(EnvKey.productUrl);
        case false:
          return describeEnum(EnvKey.devUrl);
        default:
          return describeEnum(EnvKey.devUrl);
      }
    }());

    final anonKey = remoteConfig.getString(() {
      switch (kReleaseMode) {
        case true:
          return describeEnum(EnvKey.productAnonKey);
        case false:
          return describeEnum(EnvKey.devAnonKey);
        default:
          return describeEnum(EnvKey.devAnonKey);
      }
    }());

    return FortuneRemoteConfig(
      baseUrl: baseUrl,
      mixpanelToken: mixpanelToken,
      mapAccessToken: mapAccessToken,
      mapStyleId: mayStyleId,
      mapUrlTemplate: mapUrlTemplate,
      anonKey: anonKey,
      randomDistance: randomDistance,
      refreshTime: refreshTime,
      markerCount: markerCount,
      ticketCount: ticketCount,
      testSignInEmail: testSignInEmail,
      testSignInPassword: testSignInPassword,
    );
  } catch (e) {
    throw (e is Exception) ? e.handleException() : e;
  }
}
