import 'package:foresh_flutter/data/supabase/service_ext.dart';

class IngredientEntity {
  final int id;
  final String name;
  final String imageUrl;
  final int rewardTicket;
  final IngredientType type;
  final String adUrl;
  final int distance;
  final bool isGlobal;

  IngredientEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.type,
    required this.rewardTicket,
    required this.adUrl,
    required this.distance,
    required this.isGlobal,
  });

  factory IngredientEntity.empty() {
    return IngredientEntity(
      id: 0,
      name: '',
      imageUrl: '',
      rewardTicket: 0,
      type: IngredientType.ticket,
      // assuming 'undefined' is a valid enum value for IngredientType
      adUrl: '',
      distance: 0,
      isGlobal: false,
    );
  }
}
