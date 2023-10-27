import 'package:fortune/data/supabase/service_ext.dart';

class IngredientEntity {
  final int id;
  final String exposureName;
  final String krName;
  final String enName;
  final String imageUrl;
  final int rewardTicket;
  final IngredientType type;
  final int distance;
  final String desc;

  IngredientEntity({
    required this.id,
    required this.exposureName,
    required this.imageUrl,
    required this.type,
    required this.rewardTicket,
    required this.distance,
    required this.krName,
    required this.enName,
    required this.desc,
  });

  factory IngredientEntity.empty() {
    return IngredientEntity(
      id: -1,
      exposureName: '',
      krName: '',
      enName: '',
      imageUrl: '',
      rewardTicket: 0,
      type: IngredientType.coin,
      // assuming 'undefined' is a valid enum value for IngredientType
      distance: 0,
      desc: '',
    );
  }
}
