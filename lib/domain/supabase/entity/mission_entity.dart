import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/marker_entity.dart';

class MissionEntity {
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
  final MarkerEntity? marker;
  final bool isGlobal;

  MissionEntity({
    required this.id,
    required this.bigTitle,
    required this.bigSubtitle,
    required this.detailContent,
    required this.detailTitle,
    required this.detailSubtitle,
    required this.rewardCount,
    required this.remainCount,
    required this.type,
    required this.rewardImage,
    required this.marker,
    required this.isGlobal,
  });

  factory MissionEntity.empty() {
    return MissionEntity(
      id: 0,
      bigTitle: '',
      bigSubtitle: '',
      detailContent: '',
      detailTitle: '',
      detailSubtitle: '',
      type: MissionType.normal,
      rewardCount: 0,
      remainCount: 0,
      rewardImage: '',
      isGlobal: false,
      marker: null,
    );
  }
}
