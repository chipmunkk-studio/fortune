import 'package:foresh_flutter/domain/entities/token_entity.dart';
import 'package:foresh_flutter/domain/repositories/user_normal_remote_repository.dart';
import 'package:foresh_flutter/presentation/signup/bloc/sign_up_form.dart';

import '../../core/util/usecase.dart';

class SignUpUseCase implements UseCase1<TokenEntity, RequestSignUpParams> {
  final UserNormalRemoteRepository repository;

  SignUpUseCase(this.repository);

  @override
  Future<FortuneResult<TokenEntity>> call(RequestSignUpParams params) async {
    return await repository.signUp(params);
  }
}

class RequestSignUpParams {
  final SignUpForm data;
  final String? profileImage;
  final String? pushToken;

  RequestSignUpParams({
    required this.data,
    required this.profileImage,
    required this.pushToken,
  });
}
