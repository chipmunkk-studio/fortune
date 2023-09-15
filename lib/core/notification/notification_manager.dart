import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/data/local/datasource/local_datasource.dart';
import 'package:single_item_shared_prefs/single_item_shared_prefs.dart';
import 'package:single_item_storage/storage.dart';

import 'notification_ext.dart';

const String apnsDeviceTokenKey = 'apns-device-token';
const String fcmDeviceTokenKey = 'firebase-device-token';
const String pushAlarmPrefsKey = 'push-alarm-prefs-key';

class FortuneNotificationsManager {
  late final FirebaseMessaging _fcm;
  static const String _TAG = 'NotificationsManager';
  static late final FlutterLocalNotificationsPlugin flNotification;

  final Storage<String> _fcmTokenStorage;
  final Storage<String> _apnsTokenStorage;
  final LocalDataSource localDataSource;

  bool _setupStarted = false;

  FortuneNotificationsManager(
    InitializationSettings initializationSettings, {
    Storage<String>? fcmTokenStorage,
    Storage<String>? apnsTokenStorage,
    required this.localDataSource,
  })  : _fcmTokenStorage = fcmTokenStorage ?? SharedPrefsStorage<String>.primitive(itemKey: fcmDeviceTokenKey),
        _apnsTokenStorage = apnsTokenStorage ?? SharedPrefsStorage<String>.primitive(itemKey: apnsDeviceTokenKey) {
    if (shouldConfigureFirebase()) {
      _fcm = FirebaseMessaging.instance;
    }
    flNotification = FlutterLocalNotificationsPlugin();
    flNotification.initialize(initializationSettings);
  }

  bool get setupStarted => _setupStarted;

  setupPushNotifications() async {
    if (_setupStarted) {
      FortuneLogger.error(code: '400', message: '알림매니저가 이미 초기화 되어있습니다');
    }
    _setupStarted = true;

    if (Platform.isIOS) {
      await requestPermissions();

      final apnsToken = await _fcm.getAPNSToken();
      _onAPNSTokenReceived(apnsToken);
    }

    final fcmToken = await _fcm.getToken();
    _onFCMTokenReceived(fcmToken);

    _fcm.subscribeToTopic('all');
    _fcm.onTokenRefresh.listen((token) {
      FortuneLogger.info(tag: _TAG, "FCM Token refresh");
      _onFCMTokenReceived(token);
    });

    // 앱이 포그라운드에 있을때 알림을 받는 경우.
    FirebaseMessaging.onMessage.listen((message) {
      _onMessage(message);
    });

    // 앱이 포그라운드에 있을때 알림을 클릭하는 경우.
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _onAppOpenedFromMessage(message);
    });

    // 앱이 백그라운드에 있을 때 알림을 받는 경우.
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> disablePushNotifications() async {
    await _fcm.deleteToken();
    await _fcmTokenStorage.delete();
    await _apnsTokenStorage.delete();

    _setupStarted = false;
  }

  Future<String?> getFcmPushToken() async {
    return await _fcmTokenStorage.get();
  }

  /// ios에서 필요한 권한들을 요청. (안드로이드에서는 요청 할 필요 없음)
  /// android에서 요청한다면 항상 true.
  Future<NotificationSettings> requestPermissions({
    alert = true, // 권한 요청 알림 화면을 표시 (default true)
    announcement = false, // 시리를 통해 알림의 내용을 자동으로 읽을 수 있는 권한 요청 (default false)
    badge = true, // 뱃지 업데이트 권한 요청 (default true)
    carPlay = false, // carPlay 환경에서 알림 표시 권한 요청 (default false)
    criticalAlert = false, // 중요 알림에 대한 권한 요청, 해당 알림 권한을 요청하는 이유를 app store 등록시 명시해야함 (default true)
    provisional = false, // 무중단 알림 권한 요청 (default false)
    sound = true, // 알림 소리 권한 요청 (default true)
  }) async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: alert,
      announcement: announcement,
      badge: badge,
      carPlay: carPlay,
      criticalAlert: criticalAlert,
      provisional: provisional,
      sound: sound,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FortuneLogger.info(tag: _TAG, "User granted permission");
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      FortuneLogger.info(tag: _TAG, "User granted provisional permission");
    } else {
      FortuneLogger.info(tag: _TAG, "User declined or not accepted permission");
    }

    return settings;
  }

  /// 푸시 알람이 허용되어 있는지. (안드로이드에서는 항상 on)
  Future<bool> isPushAuthorized() async {
    final notificationSettings = await _fcm.getNotificationSettings();
    return notificationSettings.authorizationStatus == AuthorizationStatus.authorized;
  }

  /// 현재 알람 권한 여부. (안드로이드에서는 항상 on)
  Future<AuthorizationStatus> getAuthorizationStatus() async {
    final notificationSettings = await _fcm.getNotificationSettings();
    return notificationSettings.authorizationStatus;
  }

  /// ios용 토큰 (그 외 안드로이드/웹은 항상 null)
  Future<String?> getAPNSToken() async {
    final token = await _fcm.getAPNSToken();
    return token;
  }

  Future<void> _onAPNSTokenReceived(String? token) async {
    FortuneLogger.info(tag: _TAG, "APNS Token $token");

    final storedToken = await _apnsTokenStorage.get();

    if (storedToken == null || storedToken != token) {
      await _apnsTokenStorage.save(token!);
    }
  }

  Future<void> _onFCMTokenReceived(String? token) async {
    FortuneLogger.info(tag: _TAG, "FCM Token $token");

    final storedToken = await _fcmTokenStorage.get();

    if (storedToken == null || storedToken != token) {
      await _fcmTokenStorage.save(token!);
    }
  }

  /// 안드로이드 한정.
  /// ios에서는 기본적으로 시스템이 보여줌.
  /// ios동작을 바꿀려면 우측 참조 > setForegroundNotificationPresentationOptions in setupPushNotifications
  _onMessage(RemoteMessage message) async {
    final isAllow = await localDataSource.getAllowPushAlarm();
    FortuneLogger.info(tag: _TAG, "_onMessage > ${message.data.toString()}, isAllow: $isAllow");
    if (isAllow) {
      await flNotification.show(
        notificationId,
        message.notification?.title,
        message.notification?.body,
        platformChannelSpecifics(androidNotificationDetails),
      );
    }
  }

  _onAppOpenedFromMessage(RemoteMessage message) {
    FortuneLogger.info(tag: _TAG, "Opened from remote message");
  }
}
