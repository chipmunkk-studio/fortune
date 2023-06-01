import 'package:foresh_flutter/domain/entities/user/terms_entity.dart';

import '../../../../core/util/usecase.dart';

abstract class UserNormalRemoteRepository {
  Future<FortuneResult<TermsEntity>> getTerms(String phoneNumber);
}
