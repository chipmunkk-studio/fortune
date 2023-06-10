import 'package:equatable/equatable.dart';

class RewardHistoryEntity extends Equatable {
  final String nickname;
  final String rewardName;
  final String rewardImage;
  final String requestTime;

  const RewardHistoryEntity({
    required this.nickname,
    required this.rewardName,
    required this.rewardImage,
    required this.requestTime,
  });

  @override
  List<Object?> get props => [
        nickname,
        rewardName,
        rewardImage,
        requestTime,
      ];
}
