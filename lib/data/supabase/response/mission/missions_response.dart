import 'package:fortune/core/util/date.dart';
import 'package:fortune/core/util/locale.dart';
import 'package:fortune/data/supabase/response/mission/mission_ext.dart';
import 'package:fortune/data/supabase/response/mission/mission_reward_response.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_reward_entity.dart';
import 'package:fortune/domain/supabase/entity/mission/missions_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'missions_response.g.dart';

enum MissionsColumn {
  id,
  krTitle,
  krContent,
  krNote,
  enTitle,
  enContent,
  missionImage,
  missionType,
  missionReward,
  deadline,
  enNote,
  isActive,
}

extension MissionsColumnExtension on MissionsColumn {
  String get name {
    switch (this) {
      case MissionsColumn.id:
        return 'id';
      case MissionsColumn.krTitle:
        return 'kr_title';
      case MissionsColumn.krContent:
        return 'kr_content';
      case MissionsColumn.krNote:
        return 'kr_note';
      case MissionsColumn.enTitle:
        return 'en_title';
      case MissionsColumn.enContent:
        return 'en_content';
      case MissionsColumn.enNote:
        return 'en_note';
      case MissionsColumn.missionImage:
        return 'mission_image';
      case MissionsColumn.missionType:
        return 'mission_type';
      case MissionsColumn.missionReward:
        return 'mission_reward';
      case MissionsColumn.deadline:
        return 'deadline';
      case MissionsColumn.isActive:
        return 'is_active';
    }
  }
}

@JsonSerializable(ignoreUnannotated: false)
class MissionsResponse extends MissionsEntity {
  @JsonKey(name: 'id')
  final double? id_;
  @JsonKey(name: 'kr_title')
  final String? krTitle_;
  @JsonKey(name: 'kr_content')
  final String? krContent_;
  @JsonKey(name: 'kr_note')
  final String? krNote_;
  @JsonKey(name: 'en_title')
  final String? enTitle_;
  @JsonKey(name: 'en_content')
  final String? enContent_;
  @JsonKey(name: 'en_note')
  final String? enNote_;
  @JsonKey(name: 'mission_image')
  final String? missionImage_;
  @JsonKey(name: 'mission_type')
  final String? missionType_;
  @JsonKey(name: 'deadline')
  final String? deadline_;
  @JsonKey(name: 'mission_reward')
  final MissionRewardResponse? missionReward_;
  @JsonKey(name: 'is_active')
  final bool? isActive_;

  MissionsResponse({
    required this.id_,
    required this.krTitle_,
    required this.krContent_,
    required this.krNote_,
    required this.enTitle_,
    required this.enContent_,
    required this.enNote_,
    required this.missionType_,
    required this.missionReward_,
    required this.missionImage_,
    required this.deadline_,
    required this.isActive_,
  }) : super(
          id: id_?.toInt() ?? -1,
          title: getLocaleContent(en: enTitle_ ?? '', kr: krTitle_ ?? ''),
          content: getLocaleContent(en: enContent_ ?? '', kr: krContent_ ?? ''),
          note: getLocaleContent(en: enNote_ ?? '', kr: krNote_ ?? ''),
          type: getMissionType(missionType_),
          image: missionImage_ ?? '',
          reward: missionReward_ ?? MissionRewardEntity.empty(),
          deadline: deadline_ ?? '',
          isActive: isActive_ == null ? false : isActive_ && !FortuneDateExtension.isDeadlinePassed(deadline_),
        );

  factory MissionsResponse.fromJson(Map<String, dynamic> json) => _$MissionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MissionsResponseToJson(this);
}
