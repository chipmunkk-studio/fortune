import 'package:foresh_flutter/data/supabase/response/mission/mission_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/marker_entity.dart';

class MissionsEntity {
  final int id;
  final String bigTitle;
  final String bigSubtitle;
  final String detailContent;
  final String detailTitle;
  final String detailSubtitle;
  final int rewardCount;
  final int remainCount;
  final String rewardImage;
  final MissionType type;
  final bool isGlobal;
  final bool isActive;
  final MarkerEntity marker;

  MissionsEntity({
    required this.id,
    required this.bigTitle,
    required this.bigSubtitle,
    required this.detailContent,
    required this.detailTitle,
    required this.detailSubtitle,
    required this.rewardCount,
    required this.remainCount,
    required this.rewardImage,
    required this.isGlobal,
    required this.isActive,
    required this.marker,
    required this.type,
  });

  factory MissionsEntity.empty() {
    return MissionsEntity(
      id: 0,
      bigTitle: '',
      bigSubtitle: '',
      detailContent: '',
      detailTitle: '',
      detailSubtitle: '',
      rewardCount: 0,
      remainCount: 0,
      type: MissionType.none,
      rewardImage: '',
      isActive: false,
      isGlobal: false,
      marker: MarkerEntity.empty(),
    );
  }
}
