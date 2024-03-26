import 'package:fortune/data/remote/response/fortune_response_ext.dart';
import 'package:fortune/domain/entity/fortune_image_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'marker_entity.freezed.dart';

@freezed
class MarkerEntity with _$MarkerEntity {
  factory MarkerEntity({
    required String id,
    required String name,
    required FortuneImageEntity image,
    @Default(MarkerItemType.NONE) MarkerItemType itemType,
    required double latitude,
    required double longitude,
    required int cost,
  }) = _MarkerEntity;

  factory MarkerEntity.initial() => MarkerEntity(
        id: '',
        name: '',
        image: FortuneImageEntity.empty(),
        itemType: MarkerItemType.NONE,
        latitude: 0.0,
        longitude: 0.0,
        cost: 0,
      );
}
