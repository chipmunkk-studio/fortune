import 'package:dartz/dartz.dart';
import 'package:fortune/core/util/usecase2.dart';
import 'package:fortune/data/error/fortune_app_failures.dart';
import 'package:fortune/domain/entity/fortune_user_entity.dart';
import 'package:fortune/domain/repository/fortune_ad_repository.dart';

class ShowAdCompleteUseCase implements UseCase1<FortuneUserEntity, int> {
  final FortuneAdRepository fortuneAdRepository;

  ShowAdCompleteUseCase({
    required this.fortuneAdRepository,
  });

  @override
  Future<FortuneResult<FortuneUserEntity>> call(int ts) async {
    try {
      final response = await fortuneAdRepository.onShowAdComplete(ts);
      return Right(response);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
