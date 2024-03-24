import 'package:fortune/data/error/fortune_error_mapper.dart';
import 'package:fortune/data/remote/api/fortune_response.dart';
import 'package:fortune/data/remote/datasource/no_auth_datasource.dart';
import 'package:fortune/data/remote/request/request_email_verify_code.dart';
import 'package:fortune/data/remote/request/request_user_register.dart';
import 'package:fortune/data/remote/request/request_verify_email.dart';
import 'package:fortune/domain/entity/email_verify_code_entity.dart';
import 'package:fortune/domain/entity/user_token_entity.dart';
import 'package:fortune/domain/entity/verify_email_entity.dart';
import 'package:fortune/domain/repository/no_auth_repository.dart';

class NoAuthRepositoryImpl implements NoAuthRepository {
  final NoAuthDataSource noAuthDataSource;
  final FortuneErrorMapper errorMapper;

  NoAuthRepositoryImpl({
    required this.noAuthDataSource,
    required this.errorMapper,
  });

  @override
  Future<EmailVerifyCodeEntity> requestEmailVerifyCode({
    required String email,
  }) async {
    try {
      final remoteData = await noAuthDataSource
          .requestEmailVerifyCode(
            RequestEmailVerifyCode(
              email: email,
            ),
          )
          .toRemoteDomainData(errorMapper);
      return remoteData;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<VerifyEmailEntity> verifyEmail({
    required String email,
    required String code,
  }) async {
    try {
      final remoteData = await noAuthDataSource
          .verifyEmail(
            RequestVerifyEmail(
              email: email,
              code: code,
            ),
          )
          .toRemoteDomainData(errorMapper);
      return remoteData;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserTokenEntity> register({
    required String signUpToken,
    required String? inviteToken,
  }) async {
    try {
      final remoteData = await noAuthDataSource
          .register(
            RequestUserRegister(
              signUpToken: signUpToken,
              inviteToken: inviteToken,
            ),
          )
          .toRemoteDomainData(errorMapper);
      return remoteData;
    } catch (e) {
      rethrow;
    }
  }
}
