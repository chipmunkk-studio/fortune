import 'eventnotice/alarm_feeds_entity.dart';
import 'fortune_user_entity.dart';
import 'marker_entity.dart';
import 'obtain_history_entity.dart';

class MyPageViewEntity {
  final FortuneUserEntity user;
  final bool isAllowPushAlarm;

  MyPageViewEntity({
    required this.user,
    required this.isAllowPushAlarm,
  });
}
