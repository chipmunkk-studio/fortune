class MissionMarkerEntity {
  final String id;
  final String name;
  final String imageUrl;
  final int requiredCount;
  final int obtainedCount;

  MissionMarkerEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.requiredCount,
    required this.obtainedCount,
  });

  factory MissionMarkerEntity.empty() => MissionMarkerEntity(
        id: '',
        name: '',
        imageUrl: '',
        requiredCount: 9,
        obtainedCount: 0,
      );
}
