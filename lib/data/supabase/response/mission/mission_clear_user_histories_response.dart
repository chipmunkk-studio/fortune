import 'package:fortune/core/util/date.dart';
import 'package:fortune/data/supabase/response/fortune_user_response.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_clear_user_histories_entity.dart';
import 'package:fortune/domain/supabase/entity/mission/missions_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import 'missions_response.dart';

part 'mission_clear_user_histories_response.g.dart';

enum MissionClearUserHistoriesColumn {
  id,
  missions,
  users,
  createdAt,
}

extension MissionClearUserHistoriesExtension on MissionClearUserHistoriesColumn {
  String get name {
    switch (this) {
      case MissionClearUserHistoriesColumn.id:
        return 'id';
      case MissionClearUserHistoriesColumn.missions:
        return 'missions';
      case MissionClearUserHistoriesColumn.users:
        return 'users';
      case MissionClearUserHistoriesColumn.createdAt:
        return 'created_at';
    }
  }
}

@JsonSerializable(ignoreUnannotated: false)
class MissionClearUserHistoriesResponse extends MissionClearUserHistoriesEntity {
  @JsonKey(name: 'id')
  final double? id_;
  @JsonKey(name: 'missions')
  final MissionsResponse? mission_;
  @JsonKey(name: 'users')
  final FortuneUserResponse? user_;
  @JsonKey(name: 'created_at')
  final String? createdAt_;

  MissionClearUserHistoriesResponse({
    required this.id_,
    required this.createdAt_,
    required this.mission_,
    required this.user_,
  }) : super(
          mission: mission_ ?? MissionsEntity.empty(),
          user: user_ ?? FortuneUserEntity.empty(),
          createdAt: FortuneDateExtension.convertTimeAgo(createdAt_),
        );

  factory MissionClearUserHistoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$MissionClearUserHistoriesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MissionClearUserHistoriesResponseToJson(this);
}
