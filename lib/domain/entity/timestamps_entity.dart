import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(ignoreUnannotated: false)
class TimestampsEntity {
  final int pig;
  final int random;
  final int marker;
  final int ad;
  final int mission;

  TimestampsEntity({
    required this.pig,
    required this.random,
    required this.marker,
    required this.ad,
    required this.mission,
  });

  factory TimestampsEntity.initial() => TimestampsEntity(
        pig: 0,
        random: 0,
        marker: 0,
        ad: 0,
        mission: 0,
      );
}
