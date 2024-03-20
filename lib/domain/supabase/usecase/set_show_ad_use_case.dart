import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/local/local_respository.dart';

class SetShowAdUseCase implements UseCase0<void> {
  final LocalRepository repository;

  SetShowAdUseCase({
    required this.repository,
  });

  @override
  Future<FortuneResultDeprecated<void>> call() async {
    try {
      await repository.setShowAdCounter();
      return const Right(null);
    } on FortuneFailureDeprecated catch (e) {
      return Left(e);
    }
  }
}
