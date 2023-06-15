import 'package:foresh_flutter/data/supabase/response/ingredient_response.dart';
import 'package:foresh_flutter/data/supabase/response/mission_response.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission_clear_condition_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mission_clear_condition_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class MissionClearConditionResponse extends MissionClearConditionEntity {
  @JsonKey(name: 'id')
  final double id_;
  @JsonKey(name: 'mission')
  final MissionResponse mission_;
  @JsonKey(name: 'ingredient')
  final IngredientResponse ingredient_;
  @JsonKey(name: 'count')
  final double count_;
  @JsonKey(name: 'title')
  final String title_;
  @JsonKey(name: 'subtitle')
  final String subtitle_;
  @JsonKey(name: 'content')
  final String content_;

  MissionClearConditionResponse({
    required this.id_,
    required this.mission_,
    required this.count_,
    required this.title_,
    required this.subtitle_,
    required this.content_,
    required this.ingredient_,
  }) : super(
          id: id_.toInt(),
          mission: mission_,
          count: count_.toInt(),
          title: title_,
          subtitle: subtitle_,
          content: content_,
          ingredient: ingredient_,
        );

  factory MissionClearConditionResponse.fromJson(Map<String, dynamic> json) =>
      _$MissionClearConditionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MissionClearConditionResponseToJson(this);
}
