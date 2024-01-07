import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/ints.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/data/supabase/response/fortune_user_response.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_clear_user_count_entity.dart';
import 'package:fortune/domain/supabase/entity/ranking_view_item_entity.dart';
import 'package:fortune/domain/supabase/repository/mission_respository.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';
import 'package:fortune/domain/supabase/request/request_get_all_users_param.dart';

class RankingUseCase implements UseCase1<RankingViewItemEntity, RequestRankingParam> {
  final UserRepository userRepository;
  final MissionsRepository missionsRepository;

  RankingUseCase({
    required this.userRepository,
    required this.missionsRepository,
  });

  @override
  Future<FortuneResult<RankingViewItemEntity>> call(RequestRankingParam param) async {
    try {
      final user = await userRepository.findUserByEmailNonNull(columnsToSelect: [
        UserColumn.email,
        UserColumn.nickname,
        UserColumn.markerObtainCount,
        UserColumn.createdAt,
        UserColumn.profileImage,
      ]);

      switch (param.type) {
        case RankingFilterType.user:
          final myRanking = await userRepository.getUserRanking(
            user.email,
            paramMarkerObtainCount: user.markerObtainCount,
            paramTicket: user.ticket,
            paramCreatedAt: user.createdAt,
          );
          final users = await _getAllUsers(param);
          return Right(
            RankingViewItemEntity(
              rankingItems: users,
              myRanking: RankingMyRankingViewItem(
                nickName: user.nickname,
                count: user.markerObtainCount.toFormatThousandNumber(),
                profile: user.profileImage,
                level: user.level,
                grade: user.grade,
                index: myRanking,
              ),
            ),
          );
        case RankingFilterType.missionClear:
          final missionClearUserRankingList = await missionsRepository.getMissionClearUsersByRanking();
          final rankingList = missionClearUserRankingList
              .map(
                (e) => RankingPagingViewItemEntity(
                    nickName: e.user.nickname,
                    count: e.clearCount.toString(),
                    profile: e.user.profileImage,
                    level: e.user.level,
                    grade: e.user.grade),
              )
              .toList();

          final myRankingIndex = _findUserMissionClearRankingIndex(missionClearUserRankingList, user.email);
          final myRankingUser = missionClearUserRankingList[myRankingIndex];
          return Right(
            RankingViewItemEntity(
              rankingItems: rankingList,
              myRanking: RankingMyRankingViewItem(
                nickName: user.nickname,
                count: myRankingIndex > 0 ? myRankingUser.clearCount.toString() : '',
                profile: user.profileImage,
                level: myRankingUser.user.level,
                grade: myRankingUser.user.grade,
                index: myRankingIndex.toString(),
              ),
            ),
          );
        default:
          return Right(_defaultRankingEntity(user));
      }
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }

  RankingViewItemEntity _defaultRankingEntity(FortuneUserEntity user) {
    return RankingViewItemEntity(
      rankingItems: List.empty(),
      myRanking: RankingMyRankingViewItem(
        nickName: user.nickname,
        count: user.markerObtainCount.toFormatThousandNumber(),
        profile: user.profileImage,
        level: user.level,
        grade: user.grade,
        index: '',
      ),
    );
  }

  // 유저 목록 불러오기
  _getAllUsers(param) async {
    return (await userRepository.getAllUsers(param))
        .map(
          (e) => RankingPagingViewItemEntity(
              nickName: e.nickname,
              count: e.markerObtainCount.toFormatThousandNumber(),
              profile: e.profileImage,
              level: e.level,
              grade: e.grade),
        )
        .toList();
  }

  _findUserMissionClearRankingIndex(List<MissionClearUserCountEntity> rankingList, String email) {
    for (int i = 0; i < rankingList.length; i++) {
      if (rankingList[i].user.email == email) {
        return i;
      }
    }
    return -1;
  }
}
