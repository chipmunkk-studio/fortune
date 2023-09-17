import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/util/permission.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'request_permission.dart';

class RequestPermissionBloc extends Bloc<RequestPermissionEvent, RequestPermissionState>
    with SideEffectBlocMixin<RequestPermissionEvent, RequestPermissionState, RequestPermissionSideEffect> {
  static const tag = "[RequestPermissionBloc]";

  RequestPermissionBloc() : super(RequestPermissionState.initial()) {
    on<RequestPermissionInit>(init);
    on<RequestPermissionNext>(next);
  }

  FutureOr<void> init(RequestPermissionInit event, Emitter<RequestPermissionState> emit) async {
    produceSideEffect(RequestPermissionStart());
  }

  FutureOr<void> next(RequestPermissionNext event, Emitter<RequestPermissionState> emit) async {
    // 한번 더 권한 확인.
    final result = await FortunePermissionUtil.requestPermission(state.permissions);
    if (result) {
      produceSideEffect(RequestPermissionSuccess());
    } else {
      produceSideEffect(RequestPermissionFail());
    }
  }
}
