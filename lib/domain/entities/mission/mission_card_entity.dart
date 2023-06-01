import 'description_entity.dart';

class MissionCardEntity {
  final int id;
  final String name;
  final String imageUrl;
  final int stock;
  final int remainedStock;
  final int targetMarkerCount;
  final int userHaveMarkerCount;
  final List<DescriptionEntity> descriptions;

  MissionCardEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.stock,
    required this.remainedStock,
    required this.targetMarkerCount,
    required this.userHaveMarkerCount,
    required this.descriptions,
  });
}
