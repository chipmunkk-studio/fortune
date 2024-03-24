import 'package:fortune/domain/entity/email_verify_code_entity.dart';
import 'package:fortune/domain/entity/fortune_user_entity.dart';
import 'package:fortune/domain/entity/marker_list_entity.dart';
import 'package:fortune/domain/entity/user_token_entity.dart';
import 'package:fortune/domain/entity/verify_email_entity.dart';

abstract class MarkerRepository {
  /// 회원가입/로그인.
  Future<MarkerListEntity> markerList(
    double latitude,
    double longitude,
  );
}
