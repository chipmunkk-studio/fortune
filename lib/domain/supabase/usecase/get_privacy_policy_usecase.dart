import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/supabase/entity/support/privacy_policy_entity.dart';
import 'package:fortune/domain/supabase/repository/support_repository.dart';

class GetPrivacyPolicyUseCase implements UseCase0<List<PrivacyPolicyEntity>> {
  final SupportRepository repository;

  GetPrivacyPolicyUseCase({required this.repository});

  @override
  Future<FortuneResult<List<PrivacyPolicyEntity>>> call() async {
    try {
      final faqs = await repository.getPrivacyPolicy();
      return Right(faqs);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
