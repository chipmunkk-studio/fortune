class MissionEntity {
  final int id;
  final String title;
  final String subtitle;
  final int rewardCount;
  final int remainCount;
  final String rewardImage;

  MissionEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.rewardCount,
    required this.remainCount,
    required this.rewardImage,
  });
}
