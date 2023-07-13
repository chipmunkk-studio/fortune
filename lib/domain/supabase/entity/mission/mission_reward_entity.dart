class MissionRewardEntity {
  final int id;
  final int totalCount;
  final String rewardName;
  final int remainCount;
  final String rewardImage;
  final String createdAt;

  MissionRewardEntity({
    required this.id,
    required this.totalCount,
    required this.rewardName,
    required this.remainCount,
    required this.rewardImage,
    required this.createdAt,
  });

  factory MissionRewardEntity.empty() => MissionRewardEntity(
        id: -1,
        totalCount: 0,
        rewardName: '',
        remainCount: 0,
        rewardImage: '',
        createdAt: '',
      );
}
