import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/local/local_respository.dart';

class GetCoinboxStopTimeUseCase implements UseCase0<int> {
  final LocalRepository repository;

  GetCoinboxStopTimeUseCase({
    required this.repository,
  });

  @override
  Future<FortuneResultDeprecated<int>> call() async {
    try {
      final time = await repository.getCoinboxStopTime();
      return Right(time);
    } on FortuneFailureDeprecated catch (e) {
      return Left(e);
    }
  }
}
