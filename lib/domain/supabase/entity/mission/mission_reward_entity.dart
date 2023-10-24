class MissionRewardEntity {
  final int id;
  final int totalCount;
  final String name;
  final int remainCount;
  final String image;
  final String note;
  final String createdAt;

  MissionRewardEntity({
    required this.id,
    required this.totalCount,
    required this.name,
    required this.remainCount,
    required this.image,
    required this.note,
    required this.createdAt,
  });

  factory MissionRewardEntity.empty() => MissionRewardEntity(
        id: -1,
        totalCount: 0,
        name: '',
        remainCount: 0,
        image: '',
        note: '',
        createdAt: '',
      );
}
