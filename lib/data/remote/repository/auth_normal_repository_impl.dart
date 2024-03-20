import 'package:fortune/data/error/fortune_error_mapper.dart';
import 'package:fortune/data/remote/api/fortune_response.dart';
import 'package:fortune/data/remote/datasource/auth_normal_datasource.dart';
import 'package:fortune/data/remote/request/request_email_verify_code.dart';
import 'package:fortune/domain/entity/request_email_verify_code_entity.dart';
import 'package:fortune/domain/repository/auth_normal_repository.dart';

class AuthNormalRepositoryImpl implements AuthNormalRepository {
  final AuthNormalDataSource authDataSource;
  final FortuneErrorMapper errorMapper;

  AuthNormalRepositoryImpl({
    required this.authDataSource,
    required this.errorMapper,
  });

  @override
  Future<RequestEmailVerifyCodeEntity> requestEmailVerifyCode({
    required String email,
  }) async {
    final remoteData = await authDataSource
        .requestEmailVerifyCode(
          RequestEmailVerifyCode(
            email: email,
          ),
        )
        .toRemoteDomainData(errorMapper);
    return remoteData;
  }
}
