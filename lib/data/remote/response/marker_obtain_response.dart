import 'package:fortune/data/remote/response/fortune_response_ext.dart';
import 'package:fortune/data/remote/response/fortune_user_response.dart';
import 'package:fortune/data/remote/response/marker_response.dart';
import 'package:fortune/data/remote/response/picked_item_response.dart';
import 'package:fortune/data/remote/response/scratch_cover_response.dart';
import 'package:fortune/domain/entity/fortune_image_entity.dart';
import 'package:fortune/domain/entity/fortune_user_entity.dart';
import 'package:fortune/domain/entity/marker_entity.dart';
import 'package:fortune/domain/entity/marker_obtain_entity.dart';
import 'package:fortune/domain/entity/picked_item_entity.dart';
import 'package:fortune/domain/entity/scratch_cover_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'marker_obtain_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class MarkerObtainResponse extends MarkerObtainEntity {
  @JsonKey(name: 'marker')
  final MarkerResponse? marker_;
  @JsonKey(name: 'user')
  final FortuneUserResponse? user_;
  @JsonKey(name: 'picked_item')
  final PickedItemResponse? pickedItem_;
  @JsonKey(name: 'cover')
  final ScratchCoverResponse? cover_;

  MarkerObtainResponse({
    this.marker_,
    this.user_,
    this.pickedItem_,
    this.cover_,
  }) : super(
          marker: MarkerEntity(
            id: marker_?.id_ ?? '',
            name: marker_?.name_ ?? '',
            image: marker_?.image_ ?? FortuneImageEntity.empty(),
            itemType: getMarkerItemType(marker_?.itemType_),
            latitude: marker_?.latitude_ ?? 0.0,
            longitude: marker_?.longitude_ ?? 0.0,
            cost: marker_?.cost_ ?? 0,
          ),
          user: user_ ?? FortuneUserEntity.empty(),
          pickedItem: pickedItem_ ?? PickedItemEntity.initial(),
          cover: cover_ ?? ScratchCoverEntity.initial(),
        );

  factory MarkerObtainResponse.fromJson(Map<String, dynamic> json) => _$MarkerObtainResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MarkerObtainResponseToJson(this);
}
