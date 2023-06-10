import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ObtainFortuneUserUseCase implements UseCase0<FortuneUserEntity?> {
  final UserRepository userRepository;

  ObtainFortuneUserUseCase({
    required this.userRepository,
  });

  @override
  Future<FortuneResult<FortuneUserEntity?>> call() async {
    return await userRepository.findUserByPhone(Supabase.instance.client.auth.currentUser?.phone);
  }
}
