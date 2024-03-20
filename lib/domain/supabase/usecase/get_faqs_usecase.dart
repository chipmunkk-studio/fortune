import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/supabase/entity/support/faq_entity.dart';
import 'package:fortune/domain/supabase/repository/support_repository.dart';

class GetFaqsUseCase implements UseCase0<List<FaqsEntity>> {
  final SupportRepository repository;

  GetFaqsUseCase({required this.repository});

  @override
  Future<FortuneResultDeprecated<List<FaqsEntity>>> call() async {
    try {
      final faqs = await repository.getFaqs();
      return Right(faqs);
    } on FortuneFailureDeprecated catch (e) {
      return Left(e);
    }
  }
}
