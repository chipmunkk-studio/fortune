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
  final IngredientPlayType playType;

  IngredientEntity({
    required this.id,
    required this.exposureName,
    required this.krName,
    required this.enName,
    required this.imageUrl,
    required this.rewardTicket,
    required this.type,
    required this.distance,
    required this.desc,
    required this.playType,
  });

  factory IngredientEntity.empty() {
    return IngredientEntity(
      id: -1,
      exposureName: '',
      krName: '',
      enName: '',
      imageUrl: '',
      rewardTicket: 0,
      type: IngredientType.none,
      distance: 0,
      playType: IngredientPlayType.webp,
      desc: '',
    );
  }

  IngredientEntity copyWith({
    int? id,
    String? exposureName,
    String? krName,
    String? enName,
    String? imageUrl,
    int? rewardTicket,
    IngredientType? type,
    IngredientPlayType? playType,
    int? distance,
    String? desc,
  }) {
    return IngredientEntity(
      id: id ?? this.id,
      exposureName: exposureName ?? this.exposureName,
      krName: krName ?? this.krName,
      enName: enName ?? this.enName,
      imageUrl: imageUrl ?? this.imageUrl,
      rewardTicket: rewardTicket ?? this.rewardTicket,
      type: type ?? this.type,
      distance: distance ?? this.distance,
      playType: playType ?? this.playType,
      desc: desc ?? this.desc,
    );
  }
}