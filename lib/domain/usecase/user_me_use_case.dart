import 'package:dartz/dartz.dart';
import 'package:fortune/core/util/usecase2.dart';
import 'package:fortune/data/error/fortune_app_failures.dart';
import 'package:fortune/domain/entity/fortune_user_entity.dart';
import 'package:fortune/domain/repository/fortune_user_repository.dart';

class UserMeUseCase implements UseCase0<FortuneUserEntity> {
  final FortuneUserRepository userRepository;

  UserMeUseCase({
    required this.userRepository,
  });

  @override
  Future<FortuneResult<FortuneUserEntity>> call() async {
    try {
      final response = await userRepository.me();
      return Right(response);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
