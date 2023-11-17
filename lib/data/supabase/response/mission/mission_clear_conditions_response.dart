import 'package:fortune/data/supabase/response/ingredient_response.dart';
import 'package:fortune/data/supabase/response/marker_response.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/domain/supabase/entity/marker_entity.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_clear_condition_entity.dart';
import 'package:fortune/domain/supabase/entity/mission/missions_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import 'missions_response.dart';

part 'mission_clear_conditions_response.g.dart';

enum MissionClearConditionColumn {
  id,
  missions,
  ingredients,
  markers,
  requireCount,
  relayCount,
}

extension MissionClearConditionColumnExtension on MissionClearConditionColumn {
  String get name {
    switch (this) {
      case MissionClearConditionColumn.id:
        return 'id';
      case MissionClearConditionColumn.missions:
        return 'missions';
      case MissionClearConditionColumn.ingredients:
        return 'ingredients';
      case MissionClearConditionColumn.markers:
        return 'markers';
      case MissionClearConditionColumn.requireCount:
        return 'require_count';
      case MissionClearConditionColumn.relayCount:
        return 'relay_count';
    }
  }
}

@JsonSerializable(ignoreUnannotated: false)
class MissionClearConditionResponse extends MissionClearConditionEntity {
  @JsonKey(name: 'id')
  final double? id_;
  @JsonKey(name: 'missions')
  final MissionsResponse? mission_;
  @JsonKey(name: 'ingredients')
  final IngredientResponse? ingredient_;
  @JsonKey(name: 'markers')
  final MarkerResponse? markers_;
  @JsonKey(name: 'require_count')
  final double? requireCount_;
  @JsonKey(name: 'relay_count')
  final int? relayCount_;

  MissionClearConditionResponse({
    required this.id_,
    required this.mission_,
    required this.requireCount_,
    required this.ingredient_,
    required this.markers_,
    required this.relayCount_,
  }) : super(
          id: id_?.toInt() ?? -1,
          mission: mission_ ?? MissionsEntity.empty(),
          ingredient: ingredient_ ?? IngredientEntity.empty(),
          requireCount: requireCount_?.toInt() ?? 999,
          relayCount: relayCount_ ?? 999,
          marker: markers_ ?? MarkerEntity.empty(),
        );

  factory MissionClearConditionResponse.fromJson(Map<String, dynamic> json) =>
      _$MissionClearConditionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MissionClearConditionResponseToJson(this);
}
