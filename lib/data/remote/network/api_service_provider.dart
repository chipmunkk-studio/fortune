import 'package:chopper/chopper.dart';
import 'package:fortune/data/remote/api/service/main_service.dart';
import 'package:fortune/data/remote/api/service/normal_auth_service.dart';
import 'package:fortune/data/remote/api/service/normal_user_service.dart';
import 'package:fortune/data/remote/api/service/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:single_item_storage/storage.dart';

import 'auth_helper_jwt.dart';
import 'credential/user_credential.dart';
import 'interceptor/auth_interceptor.dart';
import 'interceptor/http_logging_interceptor.dart';
import 'interceptor/refresh_token_authenticator.dart';

class ApiServiceProvider {
  final ChopperClient _defaultClient;
  final ChopperClient _normalClient;
  final AuthHelperJwt _authHelperJwt;

  factory ApiServiceProvider({
    required String baseUrl,
    required Storage<UserCredential> userStore,
    http.Client? httpClient,
  }) {
    // 인증이 필요하지 않은 클라이언트.
    ChopperClient normalClient = ChopperClient(
      baseUrl: Uri.parse(baseUrl),
      client: httpClient,
      converter: const JsonConverter(),
      services: [
        NoAuthService.create(),
      ],
      errorConverter: const JsonConverter(),
      interceptors: [
        const HeadersInterceptor({
          'Cache-Control': 'no-cache',
        }),
        HttpLoggerInterceptor(),
      ],
    );

    AuthHelperJwt authHelperJwt = AuthHelperJwt(
      normalClient.getService<NoAuthService>(),
      userStore,
    );

    // 인증이 필요한 클라이언트.
    ChopperClient authClient = ChopperClient(
      baseUrl: Uri.parse(baseUrl),
      client: httpClient,
      converter: const JsonConverter(),
      services: [
        UserService.create(),
        // MainService.create(),
        // 여기에 인증이 필요한 api 추가.
      ],
      authenticator: RefreshTokenAuthenticator(authHelperJwt),
      errorConverter: const JsonConverter(),
      interceptors: [
        const HeadersInterceptor({
          'Cache-Control': 'no-cache',
        }),
        HttpLoggerInterceptor(),
        AuthInterceptor(authHelperJwt),
      ],
    );

    return ApiServiceProvider.withClients(
      normalClient,
      authClient,
      authHelperJwt,
    );
  }

  ApiServiceProvider.withClients(
    ChopperClient normalClient,
    ChopperClient authClient,
    this._authHelperJwt,
  )   : _defaultClient = authClient,
        _normalClient = normalClient;

  AuthHelperJwt getAuthHelperJwt() => _authHelperJwt;


  NoAuthService getNoAuthService() => _normalClient.getService<NoAuthService>();

  UserService getUserService() => _defaultClient.getService<UserService>();

  // MainService getMarkerService() => _defaultClient.getService<MainService>();
}
