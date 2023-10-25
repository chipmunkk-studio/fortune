import 'package:fortune/core/util/date.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/domain/supabase/entity/eventnotice/alarm_feeds_entity.dart';
import 'package:fortune/domain/supabase/entity/eventnotice/alarm_rewards_history_entity.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import '../fortune_user_response.dart';
import 'alarm_reward_history_response.dart';

part 'alarm_feeds_response.g.dart';

enum AlarmFeedColumn {
  id,
  headings,
  content,
  users,
  type,
  alarmRewards,
  isRead,
  createdAt,
}

extension AlarmFeedColumnExtension on AlarmFeedColumn {
  String get name {
    switch (this) {
      case AlarmFeedColumn.id:
        return 'id';
      case AlarmFeedColumn.headings:
        return 'headings';
      case AlarmFeedColumn.content:
        return 'content';
      case AlarmFeedColumn.users:
        return 'users';
      case AlarmFeedColumn.type:
        return 'type';
      case AlarmFeedColumn.alarmRewards:
        return 'alarm_reward_history';
      case AlarmFeedColumn.isRead:
        return 'is_read';
      case AlarmFeedColumn.createdAt:
        return 'created_at';
    }
  }
}

@JsonSerializable(ignoreUnannotated: false)
class AlarmFeedsResponse extends AlarmFeedsEntity {
  @JsonKey(name: 'id')
  final double? id_;
  @JsonKey(name: 'headings')
  final String? headings_;
  @JsonKey(name: 'content')
  final String? content_;
  @JsonKey(name: 'users')
  final FortuneUserResponse? users_;
  @JsonKey(name: 'type')
  final String? type_;
  @JsonKey(name: 'alarm_reward_history')
  final AlarmRewardHistoryResponse? alarmRewards_;
  @JsonKey(name: 'is_read')
  final bool? isRead_;
  @JsonKey(name: 'created_at')
  final String? createdAt_;

  AlarmFeedsResponse({
    required this.users_,
    required this.createdAt_,
    required this.id_,
    required this.headings_,
    required this.content_,
    required this.alarmRewards_,
    required this.type_,
    required this.isRead_,
  }) : super(
          id: id_?.toInt() ?? -1,
          type: getEventNoticeType(type_),
          user: users_ ?? FortuneUserEntity.empty(),
          reward: alarmRewards_ ?? AlarmRewardHistoryEntity.empty(),
          createdAt: FortuneDateExtension.convertTimeAgo(createdAt_),
          headings: headings_ ?? '',
          content: content_ ?? '',
          isRead: isRead_ ?? true,
        );

  factory AlarmFeedsResponse.fromJson(Map<String, dynamic> json) => _$AlarmFeedsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AlarmFeedsResponseToJson(this);
}
