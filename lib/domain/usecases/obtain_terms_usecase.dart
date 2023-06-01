import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/entities/user/terms_entity.dart';
import 'package:foresh_flutter/domain/repositories/user_normal_remote_repository.dart';

class ObtainTermsUseCase implements UseCase1<void, String> {
  final UserNormalRemoteRepository repository;

  ObtainTermsUseCase(this.repository);

  @override
  Future<FortuneResult<TermsEntity>> call(String params) async {
    return await repository.getTerms(params);
  }
}
