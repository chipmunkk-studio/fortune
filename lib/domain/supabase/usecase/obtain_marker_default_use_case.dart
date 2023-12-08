import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/data/supabase/request/request_obtain_history.dart';
import 'package:fortune/data/supabase/response/fortune_user_response.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/domain/supabase/repository/obtain_history_repository.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';

class ObtainMarkerDefaultUseCase implements UseCase1<void, IngredientEntity> {
  final UserRepository userRepository;
  final ObtainHistoryRepository historyRepository;

  ObtainMarkerDefaultUseCase({
    required this.userRepository,
    required this.historyRepository,
  });

  @override
  Future<FortuneResult<void>> call(IngredientEntity param) async {
    try {
      // 유저
      final user = await userRepository.findUserByEmailNonNull(
        columnsToSelect: [
          UserColumn.id,
          UserColumn.nickname,
        ],
      );

      // 마커 획득 히스토리 추가.
      await historyRepository.insertObtainHistory(
        request: RequestObtainHistory.insert(
          ingredientId: param.id,
          userId: user.id,
          nickName: user.nickname,
          enIngredientName: param.enName,
          krIngredientName: param.krName,
          locationName: FortuneTr.msgGiftBox,
          isReward: false,
        ),
      );

      /// 랭킹 카운트로는 집계하지 않음.

      return const Right(null);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
