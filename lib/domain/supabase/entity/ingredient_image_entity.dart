import 'package:fortune/data/supabase/service_ext.dart';

class IngredientImageEntity {
  final String imageUrl;
  final IngredientImageType type;

  IngredientImageEntity({
    required this.imageUrl,
    required this.type,
  });

  factory IngredientImageEntity.empty() => IngredientImageEntity(
        imageUrl: '',
        type: IngredientImageType.webp,
      );
}
