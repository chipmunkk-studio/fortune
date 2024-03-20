import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/local/local_respository.dart';

class SetCoinboxStopTimeUseCase implements UseCase1<void, int> {
  final LocalRepository repository;

  SetCoinboxStopTimeUseCase({
    required this.repository,
  });

  @override
  Future<FortuneResultDeprecated<void>> call(int time) async {
    try {
      final result = await repository.setCoinboxStopTime(time);
      return Right(result);
    } on FortuneFailureDeprecated catch (e) {
      return Left(e);
    }
  }
}
