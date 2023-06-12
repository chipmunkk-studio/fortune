import 'package:foresh_flutter/data/supabase/service_ext.dart';

class IngredientEntity {
  final int id;
  final String krName;
  final String enName;
  final String imageUrl;
  final String disappearImage;
  final int rewardTicket;
  final IngredientType type;
  final String adUrl;
  final int distance;
  final bool isExtinct;

  IngredientEntity({
    required this.id,
    required this.krName,
    required this.enName,
    required this.imageUrl,
    required this.disappearImage,
    required this.type,
    required this.rewardTicket,
    required this.adUrl,
    required this.distance,
    required this.isExtinct,
  });

  factory IngredientEntity.empty() => IngredientEntity(
        id: -1,
        krName: '',
        enName: '',
        imageUrl: '',
        disappearImage: '',
        type: IngredientType.ticket,
        rewardTicket: 0,
        adUrl: '',
        distance: 0,
        isExtinct: true,
      );
}
