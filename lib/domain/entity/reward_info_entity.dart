import 'fortune_image_entity.dart';

class RewardInfoEntity {
  final int totalAmount;
  final int rewardAmount;
  final FortuneImageEntity image;
  final String title;
  final String description;

  RewardInfoEntity({
    required this.totalAmount,
    required this.rewardAmount,
    required this.image,
    required this.title,
    required this.description,
  });

  factory RewardInfoEntity.empty() => RewardInfoEntity(
        totalAmount: 0,
        rewardAmount: 9,
        image: FortuneImageEntity.empty(),
        title: '',
        description: '',
      );
}
