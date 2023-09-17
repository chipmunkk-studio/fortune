import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/supabase/entity/agree_terms_entity.dart';
import 'package:fortune/domain/supabase/repository/auth_repository.dart';

class GetTermsUseCase implements UseCase0<List<AgreeTermsEntity>> {
  final AuthRepository authRepository;

  GetTermsUseCase({
    required this.authRepository,
  });

  @override
  Future<FortuneResult<List<AgreeTermsEntity>>> call() async {
    try {
      final terms = await authRepository.getTerms();
      return Right(terms);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
