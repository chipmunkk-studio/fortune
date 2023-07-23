import 'package:foresh_flutter/data/supabase/service/service_ext.dart';

class IngredientEntity {
  final int id;
  final String name;
  final String imageUrl;
  final int rewardTicket;
  final IngredientType type;
  final int distance;

  IngredientEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.type,
    required this.rewardTicket,
    required this.distance,
  });

  factory IngredientEntity.empty() {
    return IngredientEntity(
      id: -1,
      name: '',
      imageUrl: '',
      rewardTicket: 0,
      type: IngredientType.ticket,
      // assuming 'undefined' is a valid enum value for IngredientType
      distance: 0,
    );
  }
}
