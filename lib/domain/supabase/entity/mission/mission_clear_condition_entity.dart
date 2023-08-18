import 'package:foresh_flutter/domain/supabase/entity/marker_entity.dart';

import '../ingredient_entity.dart';
import 'missions_entity.dart';

class MissionClearConditionEntity {
  final int id;
  final MissionsEntity mission;
  final IngredientEntity ingredient;
  final MarkerEntity marker;
  final int requireCount;

  MissionClearConditionEntity({
    required this.id,
    required this.mission,
    required this.marker,
    required this.requireCount,
    required this.ingredient,
  });
}
