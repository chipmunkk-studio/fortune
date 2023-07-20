import 'package:foresh_flutter/data/supabase/response/ingredient_response.dart';
import 'package:foresh_flutter/domain/supabase/entity/ingredient_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission/mission_clear_condition_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import 'missions_response.dart';

part 'mission_clear_conditions_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class MissionClearConditionResponse extends MissionClearConditionEntity {
  @JsonKey(name: 'id')
  final double id_;
  @JsonKey(name: 'missions')
  final MissionsResponse mission_;
  @JsonKey(name: 'ingredient')
  final IngredientResponse? ingredient_;
  @JsonKey(name: 'require_count')
  final double requireCount_;

  MissionClearConditionResponse({
    required this.id_,
    required this.mission_,
    required this.requireCount_,
    required this.ingredient_,
  }) : super(
          id: id_.toInt(),
          mission: mission_,
          ingredient: ingredient_ ?? IngredientEntity.empty(),
          requireCount: requireCount_.toInt(),
        );

  factory MissionClearConditionResponse.fromJson(Map<String, dynamic> json) =>
      _$MissionClearConditionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MissionClearConditionResponseToJson(this);
}
