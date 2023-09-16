import 'fortune_user_entity.dart';

class MyPageViewEntity {
  final FortuneUserEntity user;
  final bool isAllowPushAlarm;

  MyPageViewEntity({
    required this.user,
    required this.isAllowPushAlarm,
  });
}
