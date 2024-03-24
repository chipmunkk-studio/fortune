import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/core/util/permission.dart';
import 'package:fortune/data/remote/network/credential/user_credential.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:single_item_storage/storage.dart';

import 'request_permission.dart';

class RequestPermissionBloc extends Bloc<RequestPermissionEvent, RequestPermissionState>
    with SideEffectBlocMixin<RequestPermissionEvent, RequestPermissionState, RequestPermissionSideEffect> {
  static const tag = "[RequestPermissionBloc]";
  final Storage<UserCredential> userStorage;

  RequestPermissionBloc({
    required this.userStorage,
  }) : super(RequestPermissionState.initial()) {
    on<RequestPermissionInit>(init);
    on<RequestPermissionNext>(next);
  }

  FutureOr<void> init(RequestPermissionInit event, Emitter<RequestPermissionState> emit) async {
    produceSideEffect(RequestPermissionStart());
  }

  FutureOr<void> next(RequestPermissionNext event, Emitter<RequestPermissionState> emit) async {
    // 한번 더 권한 확인.
    final result = await FortunePermissionUtil.requestPermission(state.permissions);
    final user = await userStorage.get() ?? UserCredential.initial();
    final token = user.token;
    // 액세스 토큰이 비어 있거나, 만료 여부 확인.
    final landingRoutes =
        token.accessToken.isEmpty || token.isAccessTokenExpired() ? AppRoutes.loginRoute : AppRoutes.mainRoute;
    if (result) {
      produceSideEffect(RequestPermissionSuccess(landingRoutes));
    } else {
      produceSideEffect(RequestPermissionFail());
    }
  }
}
