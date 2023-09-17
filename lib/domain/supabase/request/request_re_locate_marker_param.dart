import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';

class RequestReLocateMarkerParam {
  final int markerId;
  final FortuneUserEntity user;

  RequestReLocateMarkerParam({
    required this.markerId,
    required this.user,
  });
}
