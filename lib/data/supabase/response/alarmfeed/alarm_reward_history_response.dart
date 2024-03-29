import 'package:fortune/data/supabase/response/fortune_user_response.dart';
import 'package:fortune/data/supabase/response/ingredient_response.dart';
import 'package:fortune/domain/supabase/entity/eventnotice/alarm_rewards_entity.dart';
import 'package:fortune/domain/supabase/entity/eventnotice/alarm_rewards_history_entity.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import 'alarm_reward_info_response.dart';

part 'alarm_reward_history_response.g.dart';

enum AlarmRewardHistoryColumn {
  id,
  users,
  alarmRewardInfo,
  ingredients,
  createdAt,
  isReceive,
}

extension AlarmRewardHistoryColumnExtension on AlarmRewardHistoryColumn {
  String get name {
    switch (this) {
      case AlarmRewardHistoryColumn.id:
        return 'id';
      case AlarmRewardHistoryColumn.users:
        return 'users';
      case AlarmRewardHistoryColumn.alarmRewardInfo:
        return 'alarm_reward_info';
      case AlarmRewardHistoryColumn.ingredients:
        return 'ingredients';
      case AlarmRewardHistoryColumn.createdAt:
        return 'created_at';
      case AlarmRewardHistoryColumn.isReceive:
        return 'is_receive';
    }
  }
}

@JsonSerializable(ignoreUnannotated: false)
class AlarmRewardHistoryResponse extends AlarmRewardHistoryEntity {
  @JsonKey(name: 'id')
  final double? id_;
  @JsonKey(name: 'users')
  final FortuneUserResponse? user_;
  @JsonKey(name: 'alarm_reward_info')
  final AlarmRewardInfoResponse? alarmRewardInfo_;
  @JsonKey(name: 'ingredients')
  final IngredientResponse? ingredients_;
  @JsonKey(name: 'created_at')
  final String? createdAt_;
  @JsonKey(name: 'is_receive')
  final bool? isReceive_;

  AlarmRewardHistoryResponse({
    required this.id_,
    required this.alarmRewardInfo_,
    required this.user_,
    required this.ingredients_,
    required this.createdAt_,
    required this.isReceive_,
  }) : super(
          id: id_?.toInt() ?? -1,
          alarmRewardInfo: alarmRewardInfo_ ?? AlarmRewardInfoEntity.empty(),
          user: user_ ?? FortuneUserEntity.empty(),
          ingredients: ingredients_ ?? IngredientEntity.empty(),
          isReceive: isReceive_ ?? true,
          createdAt: createdAt_ ?? '',
        );

  factory AlarmRewardHistoryResponse.fromJson(Map<String, dynamic> json) => _$AlarmRewardHistoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AlarmRewardHistoryResponseToJson(this);
}
