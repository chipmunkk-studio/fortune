import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/data/supabase/request/request_fortune_user.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';

class UpdateUserNickNameUseCase implements UseCase1<FortuneUserEntity, String> {
  final UserRepository userRepository;

  UpdateUserNickNameUseCase({
    required this.userRepository,
  });

  @override
  Future<FortuneResult<FortuneUserEntity>> call(String nickName) async {
    try {
      final user = await userRepository.updateUser(
        RequestFortuneUser(
          nickname: nickName,
        ),
      );
      return Right(user);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
