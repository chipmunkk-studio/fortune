import 'package:fortune/domain/entity/fortune_user_entity.dart';
import 'package:fortune/domain/entity/level_info_entity.dart';
import 'package:fortune/domain/entity/timestamps_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import 'level_info_response.dart';
import 'timestamps_response.dart';

part 'fortune_user_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class FortuneUserResponse extends FortuneUserEntity {
  @JsonKey(name: 'id')
  final String? id_;
  @JsonKey(name: 'nickname')
  final String? nickname_;
  @JsonKey(name: 'profile_image_url')
  final String? profileImageUrl_;
  @JsonKey(name: 'is_alarm')
  final bool? isAlarm_;
  @JsonKey(name: 'is_tutorial')
  final bool? isTutorial_;
  @JsonKey(name: 'coins')
  final int? coins_;
  @JsonKey(name: 'item_count')
  final int? itemCount_;
  @JsonKey(name: 'remain_coin_change_count')
  final int? remainCoinChangeCount_;
  @JsonKey(name: 'remain_random_seconds')
  final int? remainRandomSeconds_;
  @JsonKey(name: 'remain_pig_seconds')
  final int? remainPigSeconds_;
  @JsonKey(name: 'level_info')
  final LevelInfoResponse? levelInfo_;
  @JsonKey(name: 'timestamps')
  final TimestampsResponse? timestamps_;
  @JsonKey(name: 'share_url')
  final String? shareUrl_;

  FortuneUserResponse({
    this.id_,
    this.nickname_,
    this.profileImageUrl_,
    this.isAlarm_,
    this.isTutorial_,
    this.coins_,
    this.itemCount_,
    this.remainCoinChangeCount_,
    this.remainRandomSeconds_,
    this.remainPigSeconds_,
    this.levelInfo_,
    this.timestamps_,
    this.shareUrl_,
  }) : super(
          id: id_ ?? '',
          nickname: nickname_ ?? '',
          profileImageUrl: profileImageUrl_ ?? '',
          isAlarm: isAlarm_ ?? false,
          isTutorial: isTutorial_ ?? false,
          coins: coins_ ?? 0,
          itemCount: itemCount_ ?? 0,
          remainCoinChangeCount: remainCoinChangeCount_ ?? 0,
          remainRandomSeconds: remainRandomSeconds_ ?? 0,
          remainPigSeconds: remainPigSeconds_ ?? 0,
          levelInfo: levelInfo_ ?? LevelInfoEntity.initial(),
          timestamps: timestamps_ ?? TimestampsEntity.initial(),
          shareUrl: '',
        );

  factory FortuneUserResponse.fromJson(Map<String, dynamic> json) => _$FortuneUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FortuneUserResponseToJson(this);
}
