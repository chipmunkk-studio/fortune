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

class RankingUserByMissionClearCountUseCase implements UseCase0<RankingViewItemEntity> {
  final UserRepository userRepository;
  final MissionsRepository missionsRepository;

  RankingUserByMissionClearCountUseCase({
    required this.userRepository,
    required this.missionsRepository,
  });

  @override
  Future<FortuneResultDeprecated<RankingViewItemEntity>> call() async {
    try {
      final user = await userRepository.findUserByEmailNonNull(columnsToSelect: [
        UserColumn.email,
        UserColumn.nickname,
        UserColumn.markerObtainCount,
        UserColumn.createdAt,
        UserColumn.profileImage,
      ]);

      final missionClearUserRankingList = await missionsRepository.getMissionClearUsersByRanking();
      final rankingList = missionClearUserRankingList
          .map(
            (e) => RankingPagingViewItemEntity(
              nickName: e.user.nickname,
              count: e.clearCount.toString(),
              profile: e.user.profileImage,
              level: e.user.level,
              grade: e.user.grade,
            ),
          )
          .toList();

      final myRankingIndex = _findUserMissionClearRankingIndex(missionClearUserRankingList, user.email);
      final myRankingUser = myRankingIndex >= 0
          ? missionClearUserRankingList[myRankingIndex]
          : MissionClearUserCountEntity(user: user, clearCount: 0);
      return Right(
        RankingViewItemEntity(
          rankingItems: rankingList,
          myRanking: RankingMyRankingViewItem(
            nickName: user.nickname,
            count: myRankingUser.clearCount.toString(),
            profile: user.profileImage,
            level: myRankingUser.user.level,
            grade: myRankingUser.user.grade,
            index: myRankingIndex.toString(),
          ),
        ),
      );
    } on FortuneFailureDeprecated catch (e) {
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
