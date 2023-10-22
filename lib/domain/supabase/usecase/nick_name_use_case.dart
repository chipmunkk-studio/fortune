import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/local/local_respository.dart';
import 'package:fortune/domain/supabase/entity/nick_name_view_entity.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';

class NickNameUseCase implements UseCase0<NickNameViewEntity> {
  final UserRepository userRepository;
  final LocalRepository localRepository;

  NickNameUseCase({
    required this.localRepository,
    required this.userRepository,
  });

  @override
  Future<FortuneResult<NickNameViewEntity>> call() async {
    try {
      final user = await userRepository.findUserByEmailNonNull();
      final entity = NickNameViewEntity(user: user);
      return Right(entity);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
