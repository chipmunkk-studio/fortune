import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';
import 'package:fortune/domain/supabase/request/request_nickname_update_param.dart';

class UpdateUserNickNameUseCase implements UseCase1<FortuneUserEntity, RequestNickNameUpdateParam> {
  final UserRepository userRepository;

  UpdateUserNickNameUseCase({
    required this.userRepository,
  });

  @override
  Future<FortuneResultDeprecated<FortuneUserEntity>> call(RequestNickNameUpdateParam param) async {
    try {
      final user = await userRepository.updateUserNickName(
        param.email,
        nickname: param.nickName,
      );
      return Right(user);
    } on FortuneFailureDeprecated catch (e) {
      return Left(e);
    }
  }
}
