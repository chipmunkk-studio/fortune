import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:foresh_flutter/domain/supabase/entity/notification_entity.dart';

import 'notification_manager.dart';

const int NOTIFICATION_ID = 7016;
const String CHANNEL_ID = 'fortune';
const String CHANNEL_NAME = 'fortune forever';
const String CHANNEL_DESCRIPTION = 'fortune channel';

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
  CHANNEL_ID,
  CHANNEL_NAME,
  channelDescription: CHANNEL_DESCRIPTION,
  importance: Importance.defaultImportance,
  priority: Priority.defaultPriority,
);

NotificationDetails platformChannelSpecifics(AndroidNotificationDetails details) =>
    NotificationDetails(android: details);

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  final notificationMessage = message.data;
  if (notificationMessage.isNotEmpty) {
    final entity = NotificationEntity.fromJson(notificationMessage);
    await FortuneNotificationsManager.flNotification.show(
      NOTIFICATION_ID,
      entity.title,
      entity.content,
      platformChannelSpecifics(androidNotificationDetails),
    );
  }
}

bool shouldConfigureFirebase() => true;
