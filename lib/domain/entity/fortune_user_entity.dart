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

  // 'empty' 팩토리 생성자 추가
  factory FortuneUserEntity.empty() {
    return FortuneUserEntity(
      id: '',
      nickname: '',
      profileImageUrl: '',
      isAlarm: false,
      isTutorial: false,
      coins: 0,
      itemCount: 0,
      remainCoinChangeCount: 0,
      remainRandomSeconds: 0,
      remainPigSeconds: 0,
      levelInfo: LevelInfoEntity.initial(),
      timestamps: TimestampsEntity.initial(),
      shareUrl: '',
    );
  }
}
