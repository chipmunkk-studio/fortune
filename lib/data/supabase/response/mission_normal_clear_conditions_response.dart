import 'package:foresh_flutter/data/supabase/response/ingredient_response.dart';
import 'package:foresh_flutter/domain/supabase/entity/normal_mission_clear_condition_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import 'mission_normal_response.dart';

part 'mission_normal_clear_conditions_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class MissionNormalClearConditionResponse extends MissionNormalClearConditionEntity {
  @JsonKey(name: 'id')
  final double id_;
  @JsonKey(name: 'mission')
  final MissionNormalResponse mission_;
  @JsonKey(name: 'ingredient')
  final IngredientResponse ingredient_;
  @JsonKey(name: 'count')
  final double count_;

  MissionNormalClearConditionResponse({
    required this.id_,
    required this.mission_,
    required this.count_,
    required this.ingredient_,
  }) : super(
          id: id_.toInt(),
          mission: mission_,
          ingredient: ingredient_,
          count: count_.toInt(),
        );

  factory MissionNormalClearConditionResponse.fromJson(Map<String, dynamic> json) =>
      _$MissionNormalClearConditionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MissionNormalClearConditionResponseToJson(this);
}
