import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:foresh_flutter/core/notification/notification_response.dart';

import 'notification_manager.dart';

const int notificationId = 7016;
const String channelId = 'fortune';
const String channelName = 'fortune forever';
const String channelDescription = 'fortune channel';

const androidInitialize = AndroidInitializationSettings('@mipmap/ic_launcher');

const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
  // 앱이 알림 권한을 요청해야 하는지 여부.
  requestAlertPermission: true,
  // 앱이 배지 알림 권한을 요청해야 하는지 여부.
  requestBadgePermission: false,
  // 앱이 사운드 알림 권한을 요청해야 하는지 여부.
  requestSoundPermission: false,
);

const initializeSettings = InitializationSettings(
  android: androidInitialize,
  iOS: initializationSettingsDarwin,
);

AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
  channelId,
  channelName,
  channelDescription: channelDescription,
  importance: Importance.defaultImportance,
  priority: Priority.defaultPriority,
);

NotificationDetails platformChannelSpecifics(AndroidNotificationDetails details) =>
    NotificationDetails(android: details);

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  await FortuneNotificationsManager.flNotification.show(
    notificationId,
    message.notification?.title,
    message.notification?.body,
    platformChannelSpecifics(androidNotificationDetails),
  );
}

bool shouldConfigureFirebase() => true;
