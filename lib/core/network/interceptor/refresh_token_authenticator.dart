import 'dart:async';

import 'package:chopper/chopper.dart';

import '../auth_helper_jwt.dart';

class RefreshTokenAuthenticator implements Authenticator {
  final AuthHelperJwt _authHelperJwt;

  RefreshTokenAuthenticator(this._authHelperJwt);

  @override
  FutureOr<Request?> authenticate(Request request, Response response, [Request? originalRequest]) {
    return _authHelperJwt.interceptResponse(request, response);
  }
}
