import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'marker_click_info_entity.g.dart';

@JsonSerializable(nullable: true, ignoreUnannotated: false)
class MarkerClickInfoEntity extends Equatable {
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'grade')
  final int grade;

  const MarkerClickInfoEntity({
    required this.message,
    required this.grade,
  });

  factory MarkerClickInfoEntity.initial() => const MarkerClickInfoEntity(
        message: "",
        grade: 0,
      );

  factory MarkerClickInfoEntity.fromJson(Map<String, dynamic> json) => _$MarkerClickInfoEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MarkerClickInfoEntityToJson(this);

  @override
  List<Object?> get props => [
        message,
        grade,
      ];
}
