import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission_detail_param.freezed.dart';

@freezed
class MissionDetailParam with _$MissionDetailParam {
  factory MissionDetailParam({
    required String missionId,
    required int ts,
  }) = _MissionDetailParam;
}
