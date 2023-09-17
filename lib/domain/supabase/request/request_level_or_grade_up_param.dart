import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';

class RequestLevelOrGradeUpParam {
  final FortuneUserEntity prevUser;
  final FortuneUserEntity nextUser;

  RequestLevelOrGradeUpParam({
    required this.prevUser,
    required this.nextUser,
  });
}
