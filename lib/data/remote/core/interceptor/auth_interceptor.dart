import 'package:chopper/chopper.dart';

import '../auth_helper_jwt.dart';

class AuthInterceptor implements RequestInterceptor {
  static const debug = "AuthInterceptor";
  final AuthHelperJwt _authenticator;

  AuthInterceptor(this._authenticator);

  @override
  Future<Request> onRequest(Request request) {
    return _authenticator.interceptRequest(request);
  }
}
