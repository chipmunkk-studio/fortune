import 'package:foresh_flutter/data/supabase/response/fortune_user_response.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission/mission_clear_user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import 'missions_response.dart';

part 'mission_clear_user_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class MissionClearUserResponse extends MissionClearUserEntity {
  @JsonKey(name: 'id')
  final double id_;
  @JsonKey(name: 'missions')
  final MissionsResponse mission_;
  @JsonKey(name: 'users')
  final FortuneUserResponse user_;
  @JsonKey(name: 'is_receive')
  final bool isReceive_;
  @JsonKey(name: 'created_at')
  final String createdAt_;

  MissionClearUserResponse({
    required this.id_,
    required this.createdAt_,
    required this.isReceive_,
    required this.mission_,
    required this.user_,
  }) : super(
          id: id_.toInt(),
          mission: mission_,
          user: user_,
          isReceive: isReceive_,
          createdAt: createdAt_,
        );

  factory MissionClearUserResponse.fromJson(Map<String, dynamic> json) =>
      _$MissionClearUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MissionClearUserResponseToJson(this);
}
