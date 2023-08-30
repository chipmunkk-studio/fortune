import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/entity/agree_terms_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/auth_repository.dart';

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
