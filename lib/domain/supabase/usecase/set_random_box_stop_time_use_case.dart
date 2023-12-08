import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/local/local_respository.dart';

class SetRandomBoxStopTimeUseCase implements UseCase1<void, int> {
  final LocalRepository repository;

  SetRandomBoxStopTimeUseCase({
    required this.repository,
  });

  @override
  Future<FortuneResult<void>> call(int time) async {
    try {
      final result = await repository.setRandomStopTime(time);
      return Right(result);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
