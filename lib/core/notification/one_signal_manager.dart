import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/env.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

abstract class OneSignalManager {
  static init() async {
    // 디버깅 용.
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setAppId(serviceLocator<Environment>().remoteConfig.oneSignalApiKey);

    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      FortuneLogger.debug(tag: 'OneSignal', "Accepted permission: $accepted");
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      FortuneLogger.debug(tag: 'OneSignal', "권한 변경.");
    });

    OneSignal.shared.setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      FortuneLogger.debug(tag: 'OneSignal', "구독 상태 변경. ${changes.jsonRepresentation()}");
    });
  }
}
