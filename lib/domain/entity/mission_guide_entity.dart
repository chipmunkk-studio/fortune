class MissionGuideEntity {
  final String mission;
  final String reward;
  final String caution;

  MissionGuideEntity({
    required this.mission,
    required this.reward,
    required this.caution,
  });

  factory MissionGuideEntity.empty() => MissionGuideEntity(
        mission: '',
        reward: '',
        caution: '',
      );
}
