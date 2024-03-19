import 'package:foresh_flutter/core/network/api/fortune_response.dart';
import 'package:foresh_flutter/core/network/api/request/request_reward_exchange.dart';
import 'package:foresh_flutter/core/network/api/service/mission_service.dart';
import 'package:foresh_flutter/data/responses/mission/mission_detail_response.dart';
import 'package:foresh_flutter/data/responses/mission/mission_response.dart';
import 'package:foresh_flutter/domain/entities/mission/mission_detail_entity.dart';
import 'package:foresh_flutter/domain/entities/mission/mission_entity.dart';

abstract class MissionDataSource {
  Future<MissionEntity> getMissions(int page);

  Future<MissionDetailEntity> getMissionDetail(int id);

  Future<void> postRewardExchange(int id);
}

class MissionDataSourceImpl extends MissionDataSource {
  final MissionService missionService;

  MissionDataSourceImpl(this.missionService);

  @override
  Future<MissionEntity> getMissions(int page) async {
    final response = await missionService.missions(page: page).then((value) => value.toResponseData());
    final entity = MissionResponse.fromJson(response);
    return entity;
  }

  @override
  Future<MissionDetailEntity> getMissionDetail(int id) async {
    final response = await missionService.missionDetail(id).then((value) => value.toResponseData());
    final entity = MissionDetailResponse.fromJson(response);
    return entity;
  }

  @override
  Future<void> postRewardExchange(int id) async {
    final response = await missionService
        .missionClear(
          RequestRewardExchange(
            rewardId: id,
          ),
        )
        .then((value) => value.toResponseData());
    return response;
  }
}
