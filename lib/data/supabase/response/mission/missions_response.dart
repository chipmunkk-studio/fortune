import 'package:fortune/core/util/locale.dart';
import 'package:fortune/data/supabase/response/mission/mission_ext.dart';
import 'package:fortune/data/supabase/response/mission/mission_reward_response.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_reward_entity.dart';
import 'package:fortune/domain/supabase/entity/mission/missions_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'missions_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class MissionsResponse extends MissionsEntity {
  @JsonKey(name: 'id')
  final double id_;
  @JsonKey(name: 'kr_title')
  final String krTitle_;
  @JsonKey(name: 'kr_content')
  final String krContent_;
  @JsonKey(name: 'kr_note')
  final String krNote_;
  @JsonKey(name: 'en_title')
  final String enTitle_;
  @JsonKey(name: 'en_content')
  final String enContent_;
  @JsonKey(name: 'en_note')
  final String enNote_;
  @JsonKey(name: 'mission_image')
  final String missionImage_;
  @JsonKey(name: 'mission_type')
  final String missionType_;
  @JsonKey(name: 'mission_reward')
  final MissionRewardResponse? missionReward_;
  @JsonKey(name: 'is_active')
  final bool isActive_;

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
    required this.isActive_,
  }) : super(
          id: id_.toInt(),
          title: getLocaleContent(en: enTitle_ ?? '', kr: krTitle_ ?? ''),
          content: getLocaleContent(en: enContent_ ?? '', kr: krContent_ ?? ''),
          note: getLocaleContent(en: enNote_ ?? '', kr: krNote_ ?? ''),
          missionType: getMissionType(missionType_),
          missionImage: missionImage_ ?? '',
          missionReward: missionReward_ ?? MissionRewardEntity.empty(),
          isActive: isActive_,
        );

  factory MissionsResponse.fromJson(Map<String, dynamic> json) => _$MissionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MissionsResponseToJson(this);
}
