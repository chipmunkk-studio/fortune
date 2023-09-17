import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/supabase/entity/agree_terms_entity.dart';
import 'package:fortune/domain/supabase/repository/auth_repository.dart';

class GetTermsByIndexUseCase implements UseCase1<AgreeTermsEntity, int> {
  final AuthRepository authRepository;

  GetTermsByIndexUseCase({
    required this.authRepository,
  });

  @override
  Future<FortuneResult<AgreeTermsEntity>> call(int index) async {
    try {
      final terms = await authRepository.getTermsByIndex(index);
      return Right(terms);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
