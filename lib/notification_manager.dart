import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:single_item_shared_prefs/single_item_shared_prefs.dart';
import 'package:single_item_storage/storage.dart';

const String apnsDeviceTokenKey = 'apns-device-token';
const String fcmDeviceTokenKey = 'firebase-device-token';

/// To obtain an instance use `serviceLocator.get<NotificationsManager>()`
class NotificationsManager {
  late final FirebaseMessaging _fcm;
  late final FlutterLocalNotificationsPlugin flNotification;

  final Storage<String> _fcmTokenStorage;
  final Storage<String> _apnsTokenStorage;

  bool _setupStarted = false;

  static const String _TAG = 'NotificationsManager';
  static const String CHANNEL_ID = 'foreground';
  static const String CHANNEL_NAME = 'channel name';
  static const String CHANNEL_DESCRIPTION = 'channel description';

  NotificationsManager(
    InitializationSettings initializationSettings, {
    Storage<String>? fcmTokenStorage,
    Storage<String>? apnsTokenStorage,
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
      FortuneLogger.debug(tag: _TAG, "Setup: Aborting, already completed.");
    }
    _setupStarted = true;

    if (Platform.isIOS) {
      await requestPermissions();

      final apnsToken = await _fcm.getAPNSToken();
      _onAPNSTokenReceived(apnsToken);
    }

    final fcmToken = await _fcm.getToken();
    _onFCMTokenReceived(fcmToken);

    _fcm.onTokenRefresh.listen((token) {
      FortuneLogger.info(tag: _TAG, "FCM Token refresh");
      _onFCMTokenReceived(token);
    });

    FirebaseMessaging.onMessage.listen((message) {
      _onMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _onAppOpenedFromMessage(message);
    });

    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

    //TODO change this behavior depending on your app requirements
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
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

  /// Requests permissions for push notifications on iOS
  /// There is no need to call this method on Android
  /// if called on Android it will always return authorization status authorized
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
      FortuneLogger.debug(tag: _TAG, "User granted permission");
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      FortuneLogger.debug(tag: _TAG, "User granted provisional permission");
    } else {
      FortuneLogger.debug(tag: _TAG, "User declined or not accepted permission");
    }

    return settings;
  }

  /// Returns bool that indicates if push notifications are authorized
  /// On Android it is always true
  Future<bool> isPushAuthorized() async {
    // return true;

    final notificationSettings = await _fcm.getNotificationSettings();
    return notificationSettings.authorizationStatus == AuthorizationStatus.authorized;
  }

  /// Returns the current authorization status for push notifications
  /// On Android it is always authorized
  Future<AuthorizationStatus> getAuthorizationStatus() async {
    final notificationSettings = await _fcm.getNotificationSettings();
    return notificationSettings.authorizationStatus;
  }

  /// Returns ANPS token for iOS
  /// Return null for Android/web
  Future<String?> getAPNSToken() async {
    final token = await _fcm.getAPNSToken();
    return token;
  }

  Future<void> _onAPNSTokenReceived(String? token) async {
    FortuneLogger.debug(tag: _TAG, "APNS Token $token");

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

  /// Creates a local notification for Android only
  /// On iOS the system shows the remote push notification by default
  /// To change the iOS behavior see setForegroundNotificationPresentationOptions in setupPushNotifications
  _onMessage(RemoteMessage message) async {
    if (Platform.isIOS) {
      return;
    }

    String notificationTitle = message.notification!.title!;
    String notificationBody = message.notification!.body!;
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      CHANNEL_ID,
      CHANNEL_NAME,
      channelDescription: CHANNEL_DESCRIPTION,
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flNotification.show(0, notificationTitle, notificationBody, platformChannelSpecifics);
  }

  _onAppOpenedFromMessage(RemoteMessage message) {
    FortuneLogger.info(tag: _TAG, "Opened from remote message");
  }
}

Future<void> backgroundMessageHandler(message) async {
  FortuneLogger.info(tag: 'NotificationsManager', "Bg message missed. User unauthorized");
}

bool shouldConfigureFirebase() => true;
