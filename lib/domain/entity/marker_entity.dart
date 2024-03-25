import 'package:flutter/cupertino.dart';
import 'package:fortune/data/remote/response/fortune_response_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'marker_entity.freezed.dart';

@freezed
class MarkerEntity with _$MarkerEntity {
  factory MarkerEntity({
    required String id,
    required String name,
    required String imageUrl,
    @Default(MarkerItemType.NONE) MarkerItemType itemType,
    @Default(MarkerImageType.PNG) MarkerImageType imageType, // 기본값 설정
    required double latitude,
    required double longitude,
    required int cost,
  }) = _MarkerEntity;

  factory MarkerEntity.initial() => MarkerEntity(
        id: '',
        name: '',
        imageUrl: '',
        itemType: MarkerItemType.NONE,
        imageType: MarkerImageType.NONE,
        latitude: 0.0,
        longitude: 0.0,
        cost: 0,
      );
}
