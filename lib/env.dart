import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foresh_flutter/core/util/strings.dart';
import 'package:foresh_flutter/domain/entities/notification_entity.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:single_item_storage/storage.dart';

import '../core/network/auth_helper_jwt.dart';
import '../core/network/credential/token_response.dart';
import '../core/network/credential/user_credential.dart';
import '../core/util/logger.dart';
import '../di.dart';
import '../presentation/fortune_router.dart';

/*
* 안드로이드 스튜디오 환경설정.
*
* 1. run args에 --flavor=dev 추가.
* 2. build flavor 에 dev 추가.
*
* */
enum BuildType {
  dev,
  product,
}

enum EnvKey {
  PRODUCT_URL,
  DEV_URL,
  MAP_ACCESS_TOKEN,
  MAP_STYLE_ID,
  MAP_URL_TEMPLATE,
  APP_METRICA_KEY,
}

class FortuneRemoteConfig {
  final String baseUrl;
  final String mapAccessToken;
  final String mapStyleId;
  final String mapUrlTemplate;
  final String appMetricaKey;

  FortuneRemoteConfig({
    required this.baseUrl,
    required this.mapAccessToken,
    required this.mapStyleId,
    required this.mapUrlTemplate,
    required this.appMetricaKey,
  });

  @override
  String toString() {
    return "\nbaseUrl: $baseUrl,\n"
        "mapAccessToken: ${mapAccessToken.shortenForPrint()},\n"
        "mapStyleId: ${mapStyleId.shortenForPrint()},\n"
        "mapUrlTemplate: ${mapUrlTemplate.shortenForPrint()},\n"
        "appMetricaKey: $appMetricaKey\n";
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

    FortuneLogger.debug(
      "buildType: $buildType, "
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
    final metricaKey = remoteConfig.getString(describeEnum(EnvKey.APP_METRICA_KEY));
    final mapAccessToken = remoteConfig.getString(describeEnum(EnvKey.MAP_ACCESS_TOKEN));
    final mayStyleId = remoteConfig.getString(describeEnum(EnvKey.MAP_STYLE_ID));
    final mapUrlTemplate = remoteConfig.getString(describeEnum(EnvKey.MAP_URL_TEMPLATE));
    final baseUrl = remoteConfig.getString(() {
      switch (kReleaseMode) {
        case true:
          return describeEnum(EnvKey.PRODUCT_URL);
        case false:
          return describeEnum(EnvKey.DEV_URL);
        default:
          return describeEnum(EnvKey.DEV_URL);
      }
    }());
    return FortuneRemoteConfig(
      baseUrl: baseUrl,
      appMetricaKey: metricaKey,
      mapAccessToken: mapAccessToken,
      mapStyleId: mayStyleId,
      mapUrlTemplate: mapUrlTemplate,
    );
  } catch (e) {
    FortuneLogger.error("RemoteConfig Error:: $e");
  }
}

// 시작 화면 결정.
Future<String> getStartRoute(Map<String, dynamic>? data) async {
  final Storage<UserCredential> userStorage = serviceLocator();
  final AuthHelperJwt authHelperJwt = serviceLocator();
  final UserCredential loggedInUser = await userStorage.get() ?? UserCredential.initial();
  final TokenResponse? tokenResponse = loggedInUser.token;

  FortuneLogger.debug(tag: Environment.tag, "User AccessToken: ${loggedInUser.token?.accessToken?.shortenForPrint()}");

  if (tokenResponse == null) {
    // 토큰이 없는 경우 > 로그인 한 적이 없음 > 온보딩.
    return Routes.onBoardingRoute;
  } else if (tokenResponse.isRefreshTokenExpired()) {
    // 리프레시 토큰이 만료 된 경우 > 로그인 화면.
    FortuneLogger.debug(tag: Environment.tag, "리프레시토큰 만료.");
    AppMetrica.reportEvent("리프레시토큰 만료");
    return Routes.phoneNumberRoute;
  } else {
    // 액세스 토큰이 만료된 경우 > 리프레시 토큰으로 갱신.
    try {
      if (tokenResponse.isAccessTokenExpired()) {
        await authHelperJwt.refreshIfTokenExpired(token: tokenResponse);
      }
      // 만료가 되지 않은 경우에는 메인화면 보여줌.
      if (data != null) {
        final entity = NotificationEntity.fromJson(data);
        return "${Routes.mainRoute}/${entity.landingRoute}";
      } else {
        // return Routes.mainRoute;
        return "${Routes.mainRoute}/${Routes.announcementRoute}";
      }
    } catch (e) {
      // 리프레시 토큰 갱신 에러일 경우 다시 로그인.
      return Routes.phoneNumberRoute;
    }
  }
}
