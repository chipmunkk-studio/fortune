import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/ints.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/data/supabase/response/fortune_user_response.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/entity/ranking_view_item_entity.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';
import 'package:fortune/domain/supabase/request/request_get_all_users_param.dart';

class RankingUseCase implements UseCase1<RankingViewItemEntity, RequestRankingParam> {
  final UserRepository userRepository;

  RankingUseCase({
    required this.userRepository,
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
                index: myRanking,
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
          ),
        )
        .toList();
  }
}
