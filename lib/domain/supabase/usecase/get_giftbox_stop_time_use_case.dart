import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/local/local_respository.dart';

class GetGiftboxStopTimeUseCase implements UseCase0<int> {
  final LocalRepository repository;

  GetGiftboxStopTimeUseCase({
    required this.repository,
  });

  @override
  Future<FortuneResult<int>> call() async {
    try {
      final time = await repository.getGiftboxStopTime();
      return Right(time);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
