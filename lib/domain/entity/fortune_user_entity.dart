import 'package:fortune/domain/entity/level_info_entity.dart';
import 'package:fortune/domain/entity/timestamps_entity.dart';

class FortuneUserEntity {
  final String id;
  final String nickname;
  final String profileImageUrl;
  final bool isAlarm;
  final bool isTutorial;
  final int coins;
  final int itemCount;
  final int remainCoinChangeCount;
  final int remainRandomSeconds;
  final int remainPigSeconds;
  final LevelInfoEntity levelInfo;
  final TimestampsEntity timestamps;
  final String shareUrl;

  FortuneUserEntity({
    required this.id,
    required this.nickname,
    required this.profileImageUrl,
    required this.isAlarm,
    required this.isTutorial,
    required this.coins,
    required this.itemCount,
    required this.remainCoinChangeCount,
    required this.remainRandomSeconds,
    required this.remainPigSeconds,
    required this.levelInfo,
    required this.timestamps,
    required this.shareUrl,
  });
}
