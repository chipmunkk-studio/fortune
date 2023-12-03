import 'package:fortune/data/supabase/service_ext.dart';

import 'ingredient_image_entity.dart';

class IngredientEntity {
  final int id;
  final String exposureName;
  final String krName;
  final String enName;
  final IngredientImageEntity image;
  final int rewardTicket;
  final IngredientType type;
  final int distance;
  final String desc;

  IngredientEntity({
    required this.id,
    required this.exposureName,
    required this.krName,
    required this.enName,
    required this.image,
    required this.rewardTicket,
    required this.type,
    required this.distance,
    required this.desc,
  });

  factory IngredientEntity.empty() {
    return IngredientEntity(
      id: -1,
      exposureName: '',
      krName: '',
      enName: '',
      image: IngredientImageEntity.empty(),
      rewardTicket: -1,
      type: IngredientType.none,
      distance: 0,
      desc: '',
    );
  }

  IngredientEntity copyWith({
    int? id,
    String? exposureName,
    String? krName,
    String? enName,
    IngredientImageEntity? image,
    int? rewardTicket,
    IngredientType? type,
    int? distance,
    String? desc,
  }) {
    return IngredientEntity(
      id: id ?? this.id,
      exposureName: exposureName ?? this.exposureName,
      krName: krName ?? this.krName,
      enName: enName ?? this.enName,
      image: image ?? this.image,
      rewardTicket: rewardTicket ?? this.rewardTicket,
      type: type ?? this.type,
      distance: distance ?? this.distance,
      desc: desc ?? this.desc,
    );
  }
}