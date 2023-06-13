import 'package:foresh_flutter/domain/supabase/entity/mission_clear_history_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mission_clear_history_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class MissionClearHistoryResponse extends MissionClearHistoryEntity {
  @JsonKey(name: 'id')
  final double id_;
  @JsonKey(name: 'title')
  final String title_;
  @JsonKey(name: 'subtitle')
  final String subtitle_;
  @JsonKey(name: 'created_at')
  final String createdAt_;
  @JsonKey(name: 'reward_image')
  final String rewardImage_;
  @JsonKey(name: 'user_id')
  final int userId_;

  MissionClearHistoryResponse({
    required this.id_,
    required this.title_,
    required this.subtitle_,
    required this.createdAt_,
    required this.rewardImage_,
    required this.userId_,
  }) : super(
          id: id_.toInt(),
          title: title_,
          subtitle: subtitle_,
          createdAt: createdAt_,
          rewardImage: rewardImage_,
          userId: userId_,
        );

  factory MissionClearHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$MissionClearHistoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MissionClearHistoryResponseToJson(this);
}
