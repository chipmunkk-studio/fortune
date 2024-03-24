class LevelInfoEntity {
  final int level;
  final String grade;
  final int current;
  final int total;

  LevelInfoEntity({
    required this.level,
    required this.grade,
    required this.current,
    required this.total,
  });

  factory LevelInfoEntity.initial() => LevelInfoEntity(
        level: 0,
        grade: '',
        current: 0,
        total: 0,
      );
}
