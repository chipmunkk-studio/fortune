import 'package:foresh_flutter/domain/entities/reward/reward_notice_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reward_notice_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RewardNoticeResponse extends RewardNoticeEntity {
  @JsonKey(name: 'id')
  final int? id_;
  @JsonKey(name: 'title')
  final String? title_;
  @JsonKey(name: 'content')
  final String? content_;

  RewardNoticeResponse({
    this.id_,
    this.title_,
    this.content_,
  }) : super(
          id: id_ ?? 0,
          title: title_ ?? "",
          content: content_ ?? "",
        );

  factory RewardNoticeResponse.fromJson(Map<String, dynamic> json) => _$RewardNoticeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RewardNoticeResponseToJson(this);
}
