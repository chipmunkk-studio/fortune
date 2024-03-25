import 'package:fortune/data/remote/response/fortune_response_ext.dart';
import 'package:fortune/data/remote/response/fortune_user_response.dart';
import 'package:fortune/data/remote/response/marker_response.dart';
import 'package:fortune/data/remote/response/picked_item_response.dart';
import 'package:fortune/data/remote/response/scratch_cover_response.dart';
import 'package:fortune/domain/entity/fortune_user_entity.dart';
import 'package:fortune/domain/entity/level_info_entity.dart';
import 'package:fortune/domain/entity/marker_entity.dart';
import 'package:fortune/domain/entity/marker_obtain_entity.dart';
import 'package:fortune/domain/entity/picked_item_entity.dart';
import 'package:fortune/domain/entity/scratch_cover_entity.dart';
import 'package:fortune/domain/entity/timestamps_entity.dart';
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
            id: marker_?.id ?? '',
            name: marker_?.name ?? '',
            imageUrl: marker_?.imageUrl ?? '',
            itemType: getMarkerItemType(marker_?.itemType),
            latitude: marker_?.latitude ?? 0.0,
            longitude: marker_?.longitude ?? 0.0,
            cost: marker_?.cost ?? 0,
          ),
          user: FortuneUserEntity(
            id: user_?.id ?? '',
            nickname: user_?.nickname ?? '',
            profileImageUrl: user_?.profileImageUrl ?? '',
            isAlarm: user_?.isAlarm ?? false,
            isTutorial: user_?.isTutorial ?? false,
            coins: user_?.coins ?? 0,
            itemCount: user_?.itemCount ?? 0,
            remainCoinChangeCount: user_?.remainCoinChangeCount ?? 0,
            remainRandomSeconds: user_?.remainRandomSeconds ?? 0,
            remainPigSeconds: user_?.remainPigSeconds ?? 0,
            levelInfo: LevelInfoEntity(
              level: user_?.levelInfo_?.level ?? 0,
              grade: user_?.levelInfo_?.grade ?? '',
              current: user_?.levelInfo_?.current ?? 0,
              total: user_?.levelInfo_?.total ?? 0,
            ),
            timestamps: TimestampsEntity(
              pig: user_?.timestamps_?.pig ?? 0,
              random: user_?.timestamps_?.random ?? 0,
              marker: user_?.timestamps_?.marker ?? 0,
              ad: user_?.timestamps_?.ad ?? 0,
              mission: user_?.timestamps_?.mission ?? 0,
            ),
            shareUrl: user_?.shareUrl_ ?? '',
          ),
          pickedItem: PickedItemEntity(type: pickedItem_?.type ?? ''),
          cover: ScratchCoverEntity(
            title: cover_?.title ?? '',
            description: cover_?.description ?? '',
            imageUrl: cover_?.imageUrl ?? '',
          ),
        );

  factory MarkerObtainResponse.fromJson(Map<String, dynamic> json) => _$MarkerObtainResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MarkerObtainResponseToJson(this);
}
