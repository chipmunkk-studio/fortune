import 'fortune_user_entity.dart';

class MyPageViewEntity {
  final FortuneUserEntity user;
  final bool isAllowPushAlarm;
  final bool hasNewNotice;
  final bool hasNewFaq;

  MyPageViewEntity({
    required this.user,
    required this.isAllowPushAlarm,
    required this.hasNewNotice,
    required this.hasNewFaq,
  });
}
