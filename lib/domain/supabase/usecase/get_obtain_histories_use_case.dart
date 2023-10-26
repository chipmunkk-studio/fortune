import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/date.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/supabase/entity/obtain_history_entity.dart';
import 'package:fortune/domain/supabase/repository/obtain_history_repository.dart';
import 'package:fortune/domain/supabase/request/request_obtain_histories_param.dart';

class GetObtainHistoriesUseCase implements UseCase1<List<ObtainHistoryPagingViewItem>, RequestObtainHistoriesParam> {
  final ObtainHistoryRepository obtainHistoryRepository;

  GetObtainHistoriesUseCase({
    required this.obtainHistoryRepository,
  });

  @override
  Future<FortuneResult<List<ObtainHistoryPagingViewItem>>> call(RequestObtainHistoriesParam param) async {
    try {
      final missions = (await obtainHistoryRepository.getAllHistories(
        start: param.start,
        end: param.end,
        query: param.query,
      ))
          .map(
            (e) => ObtainHistoryContentViewItem(
              id: e.id,
              markerId: e.markerId,
              ingredient: e.ingredient,
              createdAt: FortuneDateExtension.convertTimeAgo(e.createdAt),
              ingredientName: e.ingredientName,
              locationName: e.locationName,
              nickName: e.nickName,
            ),
          )
          .toList();
      return Right(missions);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
