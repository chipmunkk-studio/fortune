import 'package:supabase/supabase.dart';

import 'fortune_user_entity.dart';

class VerifyPhoneNumberEntity {
  final AuthResponse authResponse;
  final FortuneUserEntity userEntity;

  VerifyPhoneNumberEntity({
    required this.authResponse,
    required this.userEntity,
  });
}
