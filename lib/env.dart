import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foresh_flutter/core/util/strings.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../core/util/logger.dart';

enum BuildType {
  dev,
  product,
}

enum EnvKey {
  anonKey,
  product,
  develop,
  mapAccessToken,
  mapStyleId,
  mapUrlTemplate,
  appMetrica,
  oneSignalApiKey,
  randomDistance,
  refreshTime,
  ticketCount,
  markerCount,
}

class FortuneRemoteConfig {
  final String anonKey;
  final String baseUrl;
  final String mapAccessToken;
  final String mapStyleId;
  final String mapUrlTemplate;
  final String appMetricaKey;
  final String oneSignalApiKey;
  final double randomDistance;
  final int refreshTime;
  final int markerCount;
  final int ticketCount;

  FortuneRemoteConfig({
    required this.baseUrl,
    required this.mapAccessToken,
    required this.mapStyleId,
    required this.mapUrlTemplate,
    required this.appMetricaKey,
    required this.anonKey,
    required this.oneSignalApiKey,
    required this.randomDistance,
    required this.markerCount,
    required this.ticketCount,
    required this.refreshTime,
  });

  @override
  String toString() {
    return "\nbaseUrl: $baseUrl,\n"
        "mapAccessToken: ${mapAccessToken.shortenForPrint()},\n"
        "mapStyleId: ${mapStyleId.shortenForPrint()},\n"
        "mapUrlTemplate: ${mapUrlTemplate.shortenForPrint()},\n"
        "appMetricaKey: $appMetricaKey\n"
        "oneSignalApiKey: $oneSignalApiKey\n"
        "refreshTime: $oneSignalApiKey\n"
        "ticketCount: $ticketCount\n"
        "markerCount: $markerCount\n"
        "randomDistance: $oneSignalApiKey\n"
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
  static final supportedLocales = [const Locale('en', 'US'), const Locale('ko', 'KR')];

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

    FirebaseCrashlytics.instance
      ..setCustomKey("appName", packageInfo.appName)
      ..setCustomKey("packageName", packageInfo.packageName)
      ..setCustomKey("version", packageInfo.version)
      ..setCustomKey("buildNumber", packageInfo.buildNumber)
      ..setCustomKey("buildType", buildType.toString())
      ..setCrashlyticsCollectionEnabled(isDebuggable ? false : true);

    /// 앱메트리카.
    AppMetrica.activate(AppMetricaConfig(remoteConfig.appMetricaKey));

    FortuneLogger.info(
      "buildType: $buildType,\n"
      "--------------configArgs--------------"
      "${remoteConfig.toString()}"
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
    final metricaKey = remoteConfig.getString(describeEnum(EnvKey.appMetrica));
    final mapAccessToken = remoteConfig.getString(describeEnum(EnvKey.mapAccessToken));
    final mayStyleId = remoteConfig.getString(describeEnum(EnvKey.mapStyleId));
    final mapUrlTemplate = remoteConfig.getString(describeEnum(EnvKey.mapUrlTemplate));
    final anonKey = remoteConfig.getString(describeEnum(EnvKey.anonKey));
    final oneSignalApiKey = remoteConfig.getString(describeEnum(EnvKey.oneSignalApiKey));
    final randomDistance = remoteConfig.getDouble(describeEnum(EnvKey.randomDistance));
    final refreshTime = remoteConfig.getInt(describeEnum(EnvKey.refreshTime));
    final ticketCount = remoteConfig.getInt(describeEnum(EnvKey.ticketCount));
    final markerCount = remoteConfig.getInt(describeEnum(EnvKey.markerCount));
    final baseUrl = remoteConfig.getString(() {
      switch (kReleaseMode) {
        case true:
          return describeEnum(EnvKey.product);
        case false:
          return describeEnum(EnvKey.develop);
        default:
          return describeEnum(EnvKey.develop);
      }
    }());
    return FortuneRemoteConfig(
      baseUrl: baseUrl,
      appMetricaKey: metricaKey,
      mapAccessToken: mapAccessToken,
      mapStyleId: mayStyleId,
      mapUrlTemplate: mapUrlTemplate,
      anonKey: anonKey,
      oneSignalApiKey: oneSignalApiKey,
      randomDistance: randomDistance,
      refreshTime: refreshTime,
      markerCount: markerCount,
      ticketCount: ticketCount,
    );
  } catch (e) {
    FortuneLogger.error("RemoteConfig Error:: $e");
  }
}
