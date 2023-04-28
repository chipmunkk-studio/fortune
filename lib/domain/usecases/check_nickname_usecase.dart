import '../../core/util/usecase.dart';
import '../repositories/user_normal_remote_repository.dart';

class CheckNicknameUseCase implements UseCase1<void, RequestCheckNickNameParams> {
  final UserNormalRemoteRepository repository;

  CheckNicknameUseCase(this.repository);

  @override
  Future<FortuneResult<void>> call(RequestCheckNickNameParams param) async {
    return await repository.checkNickname(param);
  }
}

class RequestCheckNickNameParams {
  final String nickname;

  RequestCheckNickNameParams({
    required this.nickname,
  });
}
