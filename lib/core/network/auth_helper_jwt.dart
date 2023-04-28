import 'dart:core';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/error/fortune_error_mapper.dart';
import 'package:foresh_flutter/core/network/api/fortune_response.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:single_item_storage/storage.dart';
import 'package:synchronized/synchronized.dart';

import '../error/fortune_error_message.dart';
import '../util/logger.dart';
import 'api/service/normal/normal_user_service.dart';
import 'credential/token_response.dart';
import 'credential/user_credential.dart';

const String authHeaderKey = 'Authorization';
const String contentType = 'content-type';

String authHeaderValue(String token) => 'Bearer $token';

class AuthHelperJwt {
  static final Lock _lock = Lock();

  final Storage<UserCredential> _userStore;
  final NormalUserService _userNormalSource;

  AuthHelperJwt(this._userNormalSource, this._userStore);

  Future<String?> refreshIfTokenExpired({
    required TokenResponse? token,
    String? Function(dynamic error)? onError,
  }) {
    return _lock.synchronized<String?>(() async {
      FortuneLogger.debug("refreshIfTokenExpired():: lock");
      final UserCredential loggedInUser = await _userStore.get() ?? UserCredential.initial();
      final TokenResponse? currentUser = token ?? loggedInUser.token;
      final String? currentToken = currentUser?.accessToken;
      FortuneLogger.debug("refreshIfTokenExpired():: loggedInUser: $loggedInUser");

      // 토큰이 존재하지 않을 경우. => 로그인이 필요.
      if (currentToken == null) {
        FortuneLogger.error("refreshIfTokenExpired():: Token does not exist");
        throw FortuneException(
          errorCode: FortuneErrorStatus.unauthorized,
          errorType: FortuneErrorDataReference.errorClientAuth,
          errorMessage: 'AccessToken does not exist (액세스 토큰 만료.)',
        );
      }

      // 토큰이 만료되었는지 확인.
      bool isTokenExpired = JwtDecoder.isExpired(currentToken);

      if (isTokenExpired) {
        FortuneLogger.debug("refreshIfTokenExpired():: isTokenExpired: $isTokenExpired");

        // 리프레시 토큰이 만료되었는지 확인.
        _ensureRefreshTokenNotExpired(currentUser);

        // 토큰 리프레시.
        FortuneLogger.debug("refreshIfTokenExpired():: Refreshing token...");
        final newCredential = await _refreshToken(currentUser!.refreshToken!);

        // 리프레시 성공.
        FortuneLogger.debug("refreshIfTokenExpired():: Updating old token...");
        await _userStore.save(loggedInUser.copy(token: newCredential));

        return newCredential.accessToken;
      } else {
        // 토큰이 만료되지 않은경우
        FortuneLogger.debug("refreshIfTokenExpired():: Token is not expired");
        return currentToken;
      }
    }, timeout: const Duration(seconds: 30)).catchError((e) => onError!.call(e), test: (error) {
      FortuneLogger.debug("refreshIfTokenExpired():: Exception thrown: $error");
      return onError != null;
    }).whenComplete(() {
      FortuneLogger.debug("refreshIfTokenExpired():: lock released");
    });
  }

  Future<Request?> interceptResponse(Request request, Response response) async {
    // 401 경우에만 핸들링 함.
    if (response.statusCode != 401) {
      FortuneLogger.debug("interceptResponse():: ${response.body.toString()}");
      return null;
    }

    FortuneLogger.debug("interceptResponse():: Handling 401 unauthorized request: ${request.url}");

    final Request? newRequestMaybe = await _lock.synchronized<Request?>(() async {
      FortuneLogger.debug("interceptResponse():: lock");

      // 현재토큰보다 새로운 토큰이 존재하는지 확인.
      final UserCredential? loggedInUser = await _userStore.get();
      final TokenResponse? currentUser = loggedInUser?.token;
      final String? refreshTokenCurrent = currentUser?.refreshToken;

      FortuneLogger.debug("interceptResponse():: loggedInUser: $loggedInUser");

      // 토큰이 없을 경우. => 로그인이 필요함.
      if (refreshTokenCurrent == null) {
        FortuneLogger.error("interceptResponse():: Need to login.");
        throw FortuneException(
          errorCode: FortuneErrorStatus.unauthorized,
          errorType: FortuneErrorDataReference.errorClientAuth,
          errorMessage: "Need to login (로그인이 필요합니다.)",
        );
      }

      // 리프레시 토큰이 만료됬는지 확인.
      _ensureRefreshTokenNotExpired(currentUser);

      // 토큰 리프레시.
      FortuneLogger.debug("interceptResponse():: Refreshing token...");
      final newCredential = await _refreshToken(currentUser!.refreshToken!);

      // 새로운 토큰을 저장.
      FortuneLogger.debug("interceptResponse():: Token refresh success; Saving...");
      await _userStore.save(loggedInUser!.copy(token: newCredential));

      FortuneLogger.debug("interceptResponse():: releasing lock");

      return applyHeader(
        request,
        authHeaderKey,
        newCredential.accessToken!,
        override: true,
      );
    }, timeout: const Duration(seconds: 30)).catchError((_) {}, test: (error) {
      FortuneLogger.debug("interceptResponse():: Exception thrown: $error");

      return false;
    });
    FortuneLogger.debug("interceptResponse():: lock released");
    return newRequestMaybe;
  }

  Future<Request> interceptRequest(Request request) async {
    // 헤더에 토큰이 있는지 확인.
    final String? tokenUsed = request.headers[authHeaderKey]?.substring('Bearer '.length);

    // 토큰이 있고 만료되지 않았을 경우.
    if (tokenUsed != null && !JwtDecoder.isExpired(tokenUsed)) {
      FortuneLogger.debug("interceptRequest():: Token is valid");
      return request;
    }

    // 토큰이 없거나 만료되었을 경우.
    final Request newRequestMaybe = await _lock.synchronized(
      () async {
        FortuneLogger.debug("interceptRequest():: lock");

        final UserCredential? loggedInUser = await _userStore.get();
        final TokenResponse? currentUser = loggedInUser?.token;
        final String? tokenCurrent = currentUser?.accessToken;

        FortuneLogger.debug("interceptRequest():: loggedInUser: $loggedInUser");
        // 저장된 토큰이 없는 경우. => 로그인이 필요.
        if (tokenCurrent == null) {
          FortuneLogger.error("interceptRequest():: AccessToken not exist: $request");
          throw FortuneException(
            errorCode: FortuneErrorStatus.unauthorized,
            errorType: FortuneErrorDataReference.errorClientAuth,
            errorMessage: "AccessToken not exist (액세스 토큰이 없습니다.)",
          );
        }

        // 토큰이 만료되지 않은 경우. => 스토어에 저장된 토큰이 만료되지 않은 경우.
        if (!JwtDecoder.isExpired(tokenCurrent)) {
          FortuneLogger.debug(
            'interceptRequest() - Applying token'
            '\nnewToken: $tokenCurrent'
            '\nusedToken: $tokenUsed',
          );
          return applyHeader(
            request,
            authHeaderKey,
            authHeaderValue(tokenCurrent),
            override: true,
          );
        }

        // 토큰이 만료되었고, 리프레시 토큰이 만료되었는지 확인. => 로그인이 필요.
        _ensureRefreshTokenNotExpired(currentUser);

        // 토큰 리프레시.
        FortuneLogger.debug("interceptRequest():: Refreshing token...");
        final newCredentials = await _refreshToken(currentUser!.refreshToken!);

        // 토큰 정보를 저장.
        FortuneLogger.debug("interceptRequest():: Token refresh success...");
        await _userStore.save(loggedInUser!.copy(token: newCredentials));

        return applyHeader(
          request,
          authHeaderKey,
          authHeaderValue(newCredentials.accessToken!),
          override: true,
        );
      },
      timeout: const Duration(seconds: 30),
    ).catchError((_) {}, test: (error) {
      FortuneLogger.error("interceptRequest():: Exception thrown: $error");
      return false;
    });
    FortuneLogger.debug("interceptRequest():: lock released");
    return newRequestMaybe;
  }

  void _ensureRefreshTokenNotExpired(TokenResponse? refreshToken) {
    var isExpired = refreshToken?.isRefreshTokenExpired();
    if (isExpired == null || isExpired == true) {
      FortuneLogger.error('RefreshToken is expired.');
      throw FortuneException(
        errorCode: FortuneErrorStatus.unauthorized,
        errorType: FortuneErrorDataReference.errorClientAuth,
        errorMessage: "RefreshToken is expired (리프레시 토큰이 만료되었습니다.)",
      );
    }
  }

  Future<TokenResponse> _refreshToken(String token) async {
    try {
      TokenResponse newToken = await _userNormalSource
          .refreshToken("Bearer $token")
          .timeout(const Duration(seconds: 25))
          .then((value) => TokenResponse.fromJson(value.toResponseData()));
      return newToken;
    } catch (e) {
      FortuneLogger.error('_refreshToken() - Refresh token refused');
      throw FortuneException(
        errorCode: FortuneErrorStatus.unauthorized,
        errorType: FortuneErrorDataReference.errorClientAuth,
        errorMessage: "Refresh token refused. (리프레시 토큰을 서버로부터 받아올 수 없습니다.) + ${e.toString()}",
      );
    }
  }
}
