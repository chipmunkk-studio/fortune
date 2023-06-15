import 'package:foresh_flutter/data/supabase/service_ext.dart';

class IngredientEntity {
  final int id;
  final String name;
  final String imageUrl;
  final String disappearImage;
  final int rewardTicket;
  final IngredientType type;
  final String adUrl;
  final int distance;
  final bool isExtinct;
  final bool isGlobal;

  IngredientEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.disappearImage,
    required this.type,
    required this.rewardTicket,
    required this.adUrl,
    required this.distance,
    required this.isExtinct,
    required this.isGlobal,
  });
}
