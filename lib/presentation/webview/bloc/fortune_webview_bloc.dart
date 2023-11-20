import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'fortune_webview.dart';

class FortuneWebviewBloc extends Bloc<FortuneWebviewEvent, FortuneWebviewState>
    with SideEffectBlocMixin<FortuneWebviewEvent, FortuneWebviewState, FortuneWebviewSideEffect> {
  FortuneWebviewBloc() : super(FortuneWebviewState.initial()) {
    on<FortuneWebviewInit>(init);
    on<FortuneWebviewLoading>(_loading);
    on<FortuneWebviewLoadingComplete>(_loadingComplete);
  }

  FutureOr<void> init(FortuneWebviewInit event, Emitter<FortuneWebviewState> emit) async {}

  FutureOr<void> _loadingComplete(FortuneWebviewLoadingComplete event, Emitter<FortuneWebviewState> emit) {
    emit(state.copyWith(isLoading: false));
  }

  FutureOr<void> _loading(FortuneWebviewLoading event, Emitter<FortuneWebviewState> emit) {
    emit(state.copyWith(loadingProgress: event.progress.toDouble()));
  }
}
