import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/entities/common/faq_entity.dart';
import 'package:foresh_flutter/domain/repositories/common_repository.dart';

class ObtainFaqUseCase implements UseCase1<FaqEntity, int> {
  final CommonRepository repository;

  ObtainFaqUseCase(this.repository);

  @override
  Future<FortuneResult<FaqEntity>> call(int page) async {
    return await repository.getFaq(page);
  }
}
