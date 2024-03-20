import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/local/local_respository.dart';

class GetShowAdUseCase implements UseCase0<bool> {
  final LocalRepository repository;

  GetShowAdUseCase({
    required this.repository,
  });

  @override
  Future<FortuneResultDeprecated<bool>> call() async {
    try {
      final result = await repository.getShowAd();
      return Right(result);
    } on FortuneFailureDeprecated catch (e) {
      return Left(e);
    }
  }
}
